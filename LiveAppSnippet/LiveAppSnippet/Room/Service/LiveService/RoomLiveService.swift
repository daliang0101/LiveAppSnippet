//
//  RoomLiveService.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import Foundation
import UIKit
import AVFAudio
import CocoaLumberjack

class RoomLiveService: NSObject, UTWeakObserver {
    private let appID: UInt32 = 0
    private let signkey: [UInt8] = [0xA1, 0xF6]
    
    private var roomType: LiveRoomType
    private var liveEngine: LiveEngine
    private var mineStream = MineLiveStream()
    private var muteMineAudio: Bool = false // 关闭本地麦克风
    private var streamList: [LiveStream] = [] // 房间全部流信息：入会后、引擎代理回调更新
    private var playingStreamSet = Set<String>() // 正在播放的流
    var micSeatList: [RoomSeatModel] = [] // 麦位列表：通过RoomWebService更新
    
    /// 重试：入会
    private var reLoginTimesLimit = 5
    private var reLoginTimes = 0
    
    private var stopAndRePlayNeeded: Bool = false // 上下麦需要先停止再重新拉流
    private var isJoinChannel: Bool = false // 是否已经入会（登录房间）
    private var isPublishing: Bool = false // 是否本地正在推流
    private var isPause: Bool? = false // 手机来电、闹铃，audioSession被其他App占用等场景 需要暂停引擎
    
    /// 声浪、静音 状态变化监听者（麦位组件监听声浪变化 播放声浪动画）
    typealias T = RoomLiveObserverProtocol
    var weakObservers = Array<UTWeakObject<AnyObject>>()
    
    private var joinCompletion: ((Bool) -> Void)?
    
    convenience init(roomType: LiveRoomType) {
        self.init(roomType: roomType, loginRoomCompletion: nil)
    }
    
    required init(roomType: LiveRoomType, loginRoomCompletion: ((Bool) -> Void)? = nil) {
        joinCompletion = loginRoomCompletion
        self.roomType = roomType
        let userID = UserService.shared.getMyUid()
        let userName = UserService.shared.getMyName()
        LiveEngine.setup(appId: appID, signkey: signkey)
        LiveEngine.setupEngineSpecialConfig(config: "max_channels=12")
        liveEngine = LiveEngine(uid: String(userID), userName: userName)
        super.init()
        setupEngineConfig()
        registerAudioSessionNotifications()
    }
    
    // MARK: - Public methods
    func joinChannel(name: String) {
        DDLogInfo("[VoiceRoom-Live] joinChannel |channelName:\(name)")
        mineStream.channelName = name
        updateMineRoleConfig()
        updateMineRolePlayOrPublish()
        updateMineMute()
    }
    
    func leaveChannel(name: String) {
        DDLogInfo("[VoiceRoom-Live] leaveChannel |channelName:\(mineStream.channelName)")
        stopPublishing(streamID: mineStream.publishStreamID)
        stopPlayAllBroadcaster()
        logoutRoom()
    }
    
    func setMyMicMute(mute: Bool) {
        muteMineAudio = mute
        updateMineMute()
    }

    func isSuccessJoinChannel() -> Bool {
        return isJoinChannel
    }

    func getMineSeatModel() -> RoomSeatModel? {
        micSeatList.filter {$0.user.uid == UserService.shared.getMyUid()}.first
    }

    func update(seatList: [RoomSeatModel]) {
        seatlistUpdatedHandle(seatArray: seatList)
        micSeatList = seatList
    }
    
    
    // MARK: - Private methods
    
    private func setupEngineConfig() {
        // 配置liveEngine：噪声、增益、码率、软硬编解码...
        if roomType == .VoiceRoom {
            let config = LiveEngineConfig()
            // config.xxx =
            liveEngine.setupEngineConfig(config: config)
        } else if roomType == .talk1v1 {
            let config = LiveEngineConfig()
            // config.xxx =
            liveEngine.setupEngineConfig(config: config)
        } else {
            let config = LiveEngineConfig()
            // config.xxx =
            liveEngine.setupEngineConfig(config: config)
        }
        liveEngine.roomDelegate = self
        liveEngine.playerDelegate = self
        liveEngine.publisherDelegate = self
        liveEngine.soundLevelDelegate = self
        startSoundLevelMonitor()
    }
    
    private func registerAudioSessionNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifyForAudioSessionInterrupted(_:)),
                                               name: AVAudioSession.interruptionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifyForAudioSessionSilenceSecondaryAudioHint(_:)),
                                               name: AVAudioSession.silenceSecondaryAudioHintNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifyForAudioSessionUseBegin(_:)),
                                               name: Notification.Name("AudioSessionUseBeginNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifyForAudioSessionUseEnd(_:)),
                                               name: Notification.Name("AudioSessionUseEndNotification"), object: nil)
    }
    
    /// 更新当前用户 角色相关信息
    private func updateMineRoleConfig() {
        let oldRole = mineStream.roleType
        if let model = getMineSeatModel() {
            // ‘我’在麦位列表中，则身份是主播
            mineStream.roleType = .broadcaster
            mineStream.publishStreamID = model.streamID
        } else {
            mineStream.roleType = .audience
        }
        let newRole = mineStream.roleType
        stopAndRePlayNeeded = (oldRole != .unKnown && oldRole != newRole)
    }
    
    /// 更新当前用户 推拉流状态
    private func updateMineRolePlayOrPublish() {
        if mineStream.roleType == .broadcaster {
            if !isJoinChannel {
                loginRoom(channelName: mineStream.channelName, streamID: mineStream.publishStreamID, role: mineStream.roleType)
                playAllBroadcaster()
            } else if !isPublishing {
                startPublishing(streamID: mineStream.publishStreamID, title: nil)
            }
        } else {
            stopPublishing(streamID: mineStream.publishStreamID)
            mineStream.publishStreamID = ""
            if !isJoinChannel {
                loginRoom(channelName: mineStream.channelName, streamID: "", role: .audience)
            }
        }
    }
    
    /// 更新当前用户 静音状态
    private func updateMineMute() {
        if let model = getMineSeatModel() {
            liveEngine.enableMic(enable: model.micOff ? false : !muteMineAudio)
            rawObservers.forEach {$0.roomLiveServiceMuteStateChanged(mute: muteMineAudio)}
        }
    }
    
    /// 麦位列表更新后 重新处理各麦位推拉流状态：退出麦位的停止推流
    private func seatlistUpdatedHandle(seatArray: [RoomSeatModel]) {
        micSeatList.forEach { oldSeat in
            if !oldSeat.streamID.isEmpty, seatArray.filter({$0.streamID == oldSeat.streamID}).isEmpty {
                stopPublishing(streamID: oldSeat.streamID)
            }
        }
    }
    
    /// 播放麦上所有用户的流（除自己）
    private func playAllBroadcaster() {
        DDLogInfo("[VoiceRoom-Live] startPlayAllBroadcaster |micSeatList count:\(micSeatList.count)")
        micSeatList.forEach { [weak self] seat in
            guard let self = self else { return }
            if seat.user.uid != UserService.shared.getMyUid() {
                if self.stopAndRePlayNeeded {
                    self.stopPlayStream(streamID: seat.streamID)
                }
                self.startPlayStream(streamID: seat.streamID)
            }
        }
    }
    
    /// 停止播放麦上所有用户的流
    private func stopPlayAllBroadcaster() {
        DDLogInfo("[LiveEngine-Live] stopPlayAllBroadcaster |streamList count:\(streamList.count)")
        streamList.forEach { [weak self] stream in
            self?.stopPlayStream(streamID: stream.streamID)
        }
        micSeatList.forEach { [weak self] seat in
            self?.stopPlayStream(streamID: seat.streamID)
        }
    }
}

// MARK: - AudioSession notifications
extension RoomLiveService {
    // 来电话、闹铃响等场景，触发的一般性的中断
    @objc private func onNotifyForAudioSessionInterrupted(_ notification: Notification) {
        DDLogInfo("[LiveEngine-Live] [AudioSession] notify Interrupted:\(notification.userInfo ?? [:])")
        guard let userInfo = notification.userInfo,
              let rawValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: rawValue) else {
            return
        }

        switch type {
        case .began:
            pauseResumeForAudioSession(true)
        case .ended:
            pauseResumeForAudioSession(false)
        default: break
        }
    }

    // 其他App占据AudioSession，触发的中断
    @objc private func onNotifyForAudioSessionSilenceSecondaryAudioHint(_ notification: Notification) {
        DDLogInfo("[LiveEngine-Live] [AudioSession] notify SilenceSecondaryAudioHint:\(notification.userInfo ?? [:])")
        guard let userInfo = notification.userInfo,
              let rawValue = userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? UInt,
              let type = AVAudioSession.SilenceSecondaryAudioHintType(rawValue: rawValue) else {
            return
        }
        if type == .begin {
            pauseResumeForAudioSession(true)
        } else {
            pauseResumeForAudioSession(false)
        }
    }

    // 录音或者播放开始时，需暂停引擎
    @objc private func onNotifyForAudioSessionUseBegin(_ notification: Notification) {
        DDLogInfo("[LiveEngine-Live] [AudioSession] notify UseBegin::\(notification.userInfo ?? [:])")
        pauseResumeForAudioSession(true)
    }

    // 录音或者播放结束时，需恢复引擎
    @objc private func onNotifyForAudioSessionUseEnd(_ notification: Notification) {
        DDLogInfo("[LiveEngine-Live] [AudioSession] notify UseEnd::\(notification.userInfo ?? [:])")
        pauseResumeForAudioSession(false)
    }
    
    private func pauseResumeForAudioSession(_ needPause: Bool) {
        DDLogInfo("[LiveEngine-Live] [AudioSession] liveEngine needPause:\(needPause)")
        guard isPause != needPause else { return }
        isPause = needPause
        if needPause {
            liveEngine.pauseModule()
        } else {
            liveEngine.resumeModule()
        }
    }
}

// MARK: - Business when play and publish stream
extension RoomLiveService {
    /// 进出房间
    private func loginRoom(channelName: String, streamID: String, role: LiveRoomRoleType) {
        mineStream.channelName = channelName
        mineStream.roleType = (role == .broadcaster) ? .broadcaster : .audience
        mineStream.publishStreamID = (role == .broadcaster) ? streamID : ""
        
        let result = liveEngine.joinChannel(channelName: channelName, role: role.rawValue)
        { [weak self] errorCode, streamArray in
            
            self?.isJoinChannel = (errorCode == 0)
            
            if errorCode == 0 {
                self?.reLoginTimes = 0
                self?.playingStreamSet.removeAll()
                
                if role == .broadcaster {
                    DDLogInfo("[liveEngine-Live] 主播登录房间成功 |streamID:\(streamID) |streamList count:\(streamArray.count)")
                    self?.startPublishing(streamID: streamID, title: nil)
                } else {
                    DDLogInfo("[liveEngine-Live] 观众登录房间成功 |streamID:\(streamID) |streamList count:\(streamArray.count)")
                    self?.streamList = streamArray
                    for obj in streamArray {
                        self?.startPlayStream(streamID: obj.streamID)
                    }
                }
                
            } else {
                
                DDLogError("[liveEngine-Live] \(role == .broadcaster ? "主播" : "观众")登录房间失败 |errorCode:\(errorCode)")
                self?.reLoginRoom(role: role, streamID: streamID)
            }
            
            self?.joinCompletion?(self?.isJoinChannel ?? false)
        }
        
        DDLogInfo("[liveEngine-Live] joinChannel |result:\(result)")
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    private func logoutRoom() {
        NotificationCenter.default.removeObserver(self)
        UIApplication.shared.isIdleTimerDisabled = false
        stopSoundLevelMonitor()
        let result = liveEngine.logoutRoom()
        DDLogInfo("[liveEngine-Live] logoutRoom |result:\(result)")
    }
    
    private func reLoginRoom(role: LiveRoomRoleType, streamID: String) {
        guard reLoginTimes <= reLoginTimesLimit else { return }
        reLoginTimes += 1
        DDLogInfo("[LiveEngine-Live] reLoginRoom |streamID:\(streamID.description)  |role:\(role)")
        loginRoom(channelName: mineStream.channelName, streamID: streamID, role: role)
    }
    
    
    /// 推流
    private func startPublishing(streamID: String, title: String?) {
        let streamModeL3 = GlobalConfigManager.shared.settingConfig.audioSettings.streamModeL3
        liveEngine.enableVAD(enable: streamModeL3) // 是否开启语音活动检测
        liveEngine.enableDTX(enable: streamModeL3) // 是否开启离散音频包发送
        liveEngine.startPublishing(streamID: streamID, title: title, flag: .JOIN_PUBLISH)
        DDLogInfo("[liveEngine-Live] startPublishing |streamID:\(streamID) |streamModeL3:\(streamModeL3)")
    }
    
    private func stopPublishing(streamID: String) {
        isPublishing = false
        let result = liveEngine.stopPlayStream(streamID: streamID)
        updatePlayingStreamSet(result: result, isPlaying: false, streamID: streamID)
        DDLogInfo("[liveEngine-Live] stopPublishing |streamID:\(streamID) |result:\(result)")
    }
    
    
    /// 拉流
    private func startPlayStream(streamID: String) {
        guard !playingStreamSet.contains(streamID) else {
            return
        }
        var result = false
        let extraInfo = LiveStreamExtraInfo()
        let streamModeL3 = GlobalConfigManager.shared.settingConfig.audioSettings.streamModeL3
        if roomType == .VoiceRoom {
            if streamModeL3 {
                // L3开启：麦上RTC，麦下L3
                extraInfo.mode = (mineStream.roleType == .broadcaster) ? .Stream_RTC : .Stream_L3
            } else {
                // L3关闭：麦上RTC，麦下CDN
                extraInfo.mode = (mineStream.roleType == .broadcaster) ? .Stream_RTC : .Stream_CDN
            }
        } else {
            extraInfo.mode = (mineStream.roleType == .broadcaster) ? .Stream_RTC : .Stream_CDN
        }
        
        let v: UIView? = nil
        result = liveEngine.startPlayStream(streamID: streamID, renderView: v, extraInfo: extraInfo)
        updatePlayingStreamSet(result: result, isPlaying: true, streamID: streamID)
        DDLogInfo("[liveEngine-Live] startPlaying |streamID:\(streamID) |streamModeL3:\(streamModeL3) |extraInfo.Mode:\(extraInfo.mode.rawValue) |result:\(result)")
    }
    
    private func stopPlayStream(streamID: String) {
        let result = liveEngine.stopPlayStream(streamID: streamID)
        updatePlayingStreamSet(result: result, isPlaying: false, streamID: streamID)
        DDLogInfo("[liveEngine-Live] stopPlaying |streamID:\(streamID) |result:\(result)")
    }
    
    
    /// 音浪检测
    @discardableResult
    func startSoundLevelMonitor() -> Bool {
        let result = liveEngine.startSoundLevelMonitor()
        DDLogInfo("[liveEngine-Live] startSoundLevelMonitor |result:\(result)")
        return result
    }
    
    @discardableResult
    private func stopSoundLevelMonitor() -> Bool {
        let result = liveEngine.stopSoundLevelMonitor()
        DDLogInfo("[liveEngine-Live] stopSoundLevelMonitor |result:\(result)")
        return result
    }
    
    
    /// 更新正在拉的流id集合
    private func updatePlayingStreamSet(result: Bool, isPlaying: Bool, streamID: String) {
        guard result else { return }
        if isPlaying {
            playingStreamSet.insert(streamID)
        } else {
            playingStreamSet = playingStreamSet.filter({ $0 != streamID })
        }
    }
    
}

// MARK: - LiveEngine delegate event handle
extension RoomLiveService {
    private func onSoundLevelUpdateHandle(soundLevels: [LiveSoundLevel]) {
        let sounds = soundLevels.map {RoomLiveSoundInfo(streamID: $0.streamID, soundLevel: $0.soundLevel)}
        rawObservers.forEach {$0.roomLiveServiceSoundLevelChanged(soundInfos: sounds)}
    }
}

// MARK: - LiveEngine Delegates
extension RoomLiveService: LiveEngineRoomDelegate {
    // 推拉流状态回调（成功、失败）：更新isJoinChannel、isPublishing、playingStreamSet，失败重试
}

extension RoomLiveService: LiveEnginePlayerDelegate {
    
}

extension RoomLiveService: LiveEnginePublisherDelegate {
    
}

extension RoomLiveService: LiveEngineSoundLevelDelegate {
    func liveEngineOnSoundLevelUpdate(soundLevels: [LiveSoundLevel]) {
        onSoundLevelUpdateHandle(soundLevels: soundLevels)
    }
}
