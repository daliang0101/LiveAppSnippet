//
//  RoomWebObserver.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import Foundation

protocol RoomWebObserverProtocol: AnyObject {
    func roomWebServiceReceiveMessage(_ message: RoomWebMessage)
}

/// 房间消息类型很多，每种类型消息的监听者数量不定
class RoomWebObservers: UTWeakObserver {
    typealias T = RoomWebObserverProtocol
    var weakObservers: Array<UTWeakObject<AnyObject>> = Array<UTWeakObject<AnyObject>>()
}
