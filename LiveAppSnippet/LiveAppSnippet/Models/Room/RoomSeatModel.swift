//
//  RoomSeatModel.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/27.
//

import Foundation

/// 麦位状态
enum RoomSeatStatus: Int {
    case FreeSeatMic = 0 // 空闲-无静音
    case FreeSeatMicAndMute = 1 // 空闲-静音
    case GuestSeatMicAndUnMute = 2 // 有人-无静音
    case GuestSeatMicAndMute = 3 // 有人-静音
    case LockSeatMic = 4 // 封麦
}

/// 麦位
class RoomSeatModel {
    var user: User = User()
    /// 麦位用户推流id
    var streamID: String = ""
    
    /// 是否静音
    var micOff: Bool = false
}
