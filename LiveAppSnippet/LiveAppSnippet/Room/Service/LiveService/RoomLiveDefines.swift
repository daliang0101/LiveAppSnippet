//
//  RoomLiveDefines.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/28.
//

import Foundation

/// 语音房类型
enum LiveRoomType: String {
    case VoiceRoom // 普通语音房
    case talk1v1 // 一对一通话
}

/// 语音房用户角色
enum LiveRoomRoleType: Int32 {
    case unKnown = 0
    case broadcaster = 1 // 主播：占据麦位，发送并接受音频流
    case audience = 2 // 观众：不占据麦位，只接受音频流
}

/// ‘我的’流信息
class MineLiveStream {
    var roleType: LiveRoomRoleType = .unKnown
    var userID: String = ""
    var userName: String = ""
    var publishStreamID: String = "" // 推流id，主播有
    var channelName: String = ""
}
