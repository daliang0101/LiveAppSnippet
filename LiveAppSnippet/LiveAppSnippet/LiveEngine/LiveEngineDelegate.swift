//
//  LiveEngineDelegate.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import Foundation

/**
 SDK房间信息 回调封装：初始化、连接状态，用户被踢出房间、流附加信息更新、房间内用户的网络质量等
 */
@objc public protocol LiveEngineRoomDelegate : NSObjectProtocol {
    
}


/**
 SDK拉流 回调封装：播放流状态(状态码)、质量，收到远端音视频首帧，视频尺寸变化，解码失败
 */
@objc public protocol LiveEnginePlayerDelegate : NSObjectProtocol {
    
}


/**
 SDK推流代理 回调封装：推流状态(状态码)、质量，采集、发送音视频首帧，视频编码器错误
 */
@objc public protocol LiveEnginePublisherDelegate : NSObjectProtocol {
    
}

/**
 SDK推流音浪信息更新 回调封装：房间内所有流的音浪信息，房间内采集的音浪信息（自己推的流）
 */
@objc public protocol LiveEngineSoundLevelDelegate: NSObjectProtocol {
    func liveEngineOnSoundLevelUpdate(soundLevels: [LiveSoundLevel])
}


/**
 SDK设备事件 回调封装：无权限、被Siri占用、采集声音过低
 */
@objc public protocol LiveEngineDeviceEventDelegate: NSObjectProtocol {
    
}
