//
//  RoomComponentOrder.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/25.
//

import Foundation

/** 各组件的视图层级顺序 **/


/// 媒体组件层级顺序：如麦位
enum RoomComponentMediaOrder: Int {
    case background = 80
    case micSeat
}

/// 基本业务组件层级顺序：如消息流、礼物面板、底部工具栏
enum RoomComponentBaseOrder: Int {
    case msgFlow = 12
    case bottomBar
    case showGift
}
