//
//  LiveEngineProtocol.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import UIKit

@objc public protocol LiveEngineAPIProtocol {
    /// 引擎配置（通用）
    func setupEngineConfig(config: LiveEngineConfig?)
    
    /// 引擎特定配置
    static func setupEngineSpecialConfig(config: String)
    
    /// 销毁引擎
    func destoryEngine()
    
    /// 开始入会
    @discardableResult
    func joinChannel(channelName: String, role: Int32, withCompletion completion: @escaping (_ errorCode: Int32, _ streamArray: [LiveStream]) -> Void) -> Bool
    
    /// 退出会议
    func leaveChannel()
        
    /// 开始推流
    func startPublishing(streamID: String, title: String?, flag: LiveEnginePublishFlag)

    /// 停止推流
    @discardableResult
    func stopPublishing() -> Bool
    
    @discardableResult
    func stopPlayStream(streamID: String?) -> Bool
    
    /// 开始拉流
    @discardableResult
    func startPlayStream(streamID: String?, renderView: UIView?, extraInfo: LiveStreamExtraInfo?) -> Bool

    ///退出房间
    @discardableResult
    func logoutRoom () -> Bool

    ///声音检测
    @discardableResult
    func startSoundLevelMonitor() -> Bool
    
    @discardableResult
    func stopSoundLevelMonitor() -> Bool
    
    /// 暂停音频
    func pauseModule()
    
    func resumeModule()
    
    /// 设置编码格式
    
    /// 静音
    @discardableResult
    func enableMic(enable: Bool) -> Bool
    
    /// 是否开启离散音频包发送
    func enableDTX(enable: Bool)

    /// 是否开启语音活动检测
    func enableVAD(enable: Bool)
    
}
