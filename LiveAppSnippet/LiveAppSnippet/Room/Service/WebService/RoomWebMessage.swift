//
//  RoomWebMessage.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import Foundation

/// 房间消息类型：rawValue值与网络原始类型值保持一致
enum RoomWebMessageType: Int {
    case Unknown
    
    case officalText // 官方消息
    
    case plainText // 纯文本
    
    case newComing // 用户进房通知
    
    // ...
}

final class RoomWebMessage {
    /** 消息公有信息 */
    private(set) var uid: Int = 0 // 消息发送者id
    private(set) var roomId: Int = 0 // 房间id
    private(set) var roomMasterUid: Int // 房主id
    private(set) var seq: Int // 消息唯一序列号 (一次直播过程)
    private(set) var type: RoomWebMessageType = .Unknown
    
    /** 消息具体信息 */
    private(set) var msgInfo: RoomWebMessageInfoBase
    
    init(nty: Proto_Room_Nty) {
        uid = nty.uid
        roomId = nty.roomId
        roomMasterUid = nty.roomMasterUid
        seq = nty.seq
        type = RoomWebMessageType(rawValue: nty.contentType) ?? .Unknown
        
        let MessageInfoClass = RoomWebMessage.messageTypeMap[type] ?? RoomWebMessageInfoBase.self
        msgInfo = MessageInfoClass.init(data: nty.content)
    }
}
extension RoomWebMessage {
    static var messageTypeMap: [RoomWebMessageType: RoomWebMessageInfoBase.Type] = [
        .officalText: RoomWebMessageInfoOfficialText.self,
        .plainText: RoomWebMessageInfoPlainText.self,
        .newComing: RoomWebMessageInfoNewComing.self
    ]
}

class RoomWebMessageInfoBase {
    required init(data: Data) {}
}

class RoomWebMessageInfoOfficialText: RoomWebMessageInfoBase {
    // ...
}

class RoomWebMessageInfoPlainText: RoomWebMessageInfoBase {
    // ...
}

class RoomWebMessageInfoNewComing: RoomWebMessageInfoBase {
    // ...
}


class RoomMetaData: RoomWebMessageInfoBase {
    /// 房间介绍、标题、背景图 ...
}
