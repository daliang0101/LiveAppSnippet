//
//  LiveEngine.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import Foundation
import UIKit
//import RTC_SDK

@objcMembers
public class LiveEngine: NSObject {
    public static var APPID: UInt32 = 0
    public static var Signkey: [UInt8] = []
    var rtcSdkApi:Any? /// 厂商SDK_API
    
    weak var roomDelegate: LiveEngineRoomDelegate?
    weak var soundLevelDelegate: LiveEngineSoundLevelDelegate?
    weak var playerDelegate: LiveEnginePlayerDelegate?
    weak var publisherDelegate: LiveEnginePublisherDelegate?

    public required init(uid: String, userName: String, liveConfig: LiveEngineConfig? = nil)
    {
        super.init()
        setupRTC_SDK(uid: uid, userName: userName)
        setupEngineConfig(config: liveConfig)
    }
    
    public class func setup(appId: UInt32 , signkey: [UInt8]) {
        LiveEngine.APPID = appId
        LiveEngine.Signkey = signkey
    }
    
    public func setupRTC_SDK(uid: String, userName: String) {
//        RTC_SDK.setConfigxxx(...) 特定配置
//        RTC_SDK.setUser(uid: uid, name: userName)
        
        // 初始化RTC_SDK
//        let data = Data(bytes: LiveEngine.Signkey, count: 32)
//        rtcSdkApi = RTC_SDK(appId: LiveEngine.APPID, appSignature: data, completionBlock: {})
        
        // 设置各种代理
//        rtcSdkApi.setXXXDelegate(self)
    }
}

// MARK: - LiveEngineAPIProtocol
extension LiveEngine: LiveEngineAPIProtocol {
    
    public func setupEngineConfig(config: LiveEngineConfig?) {}
    
    public static func setupEngineSpecialConfig(config: String) {}
    
    public func destoryEngine() {}
    
    public func joinChannel(channelName: String, role: Int32, withCompletion completion: @escaping (Int32, [LiveStream]) -> Void) -> Bool {
        false
    }
    
    public func leaveChannel() {}
    
    public func startPublishing(streamID: String, title: String?, flag: LiveEnginePublishFlag) {}
    
    public func stopPublishing() -> Bool {true}
    
    public func stopPlayStream(streamID: String?) -> Bool {true}
    
    @discardableResult
    public func startPlayStream(streamID:String?,renderView:UIView?,extraInfo:LiveStreamExtraInfo?) -> Bool {true}
    
    @discardableResult
    public func logoutRoom () -> Bool {true}
    
    public func pauseModule() {}
    public func resumeModule() {}
    
    
    @discardableResult
    public func enableMic(enable: Bool) -> Bool {true}
    
    public func enableDTX(enable: Bool) {}
    
    public func enableVAD(enable: Bool) {}
    
    @discardableResult
    public func startSoundLevelMonitor() -> Bool {true}
    
    @discardableResult
    public func stopSoundLevelMonitor() -> Bool {true}
}

// MARK: - RTC_SDK_delegate
//
//extension LiveEngine: RTC_SDK_RoomDelegate {
//
//}


//
//extension LiveEngine: RTC_SDK_PlayerDelegate {
//
//}


//
//extension LiveEngine: RTC_SDK_PublisherDelegate {
//
//}


//
//extension LiveEngine: RTC_SDK_SoundLevelDelegate {
//    public func onSoundLevelUpdate(_ soundLevels: [RTC_SDK_soundLevelInfo]) {
//        var sounds = [LiveSoundInfo]()
//        // ...
//        soundLevelDelegate?.liveEngineOnSoundLevelUpdate(soundLevels: sounds)
//    }
//}


//
//extension LiveEngine: RTC_SDK_DeviceEventDelegate {
//
//}
