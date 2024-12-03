//
//  Proto_Room_Nty.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/28.
//

import Foundation

/** 模拟Server返回的原始消息结构体，客户端应解析转换成自己定义的，不要直接用**/
/** 这里假设前后端数据交换格式 protobuff **/



enum Proto_Room_NtyType: Int {
    case Unknown
    
    case officalText // 官方消息
    
    case plainText // 纯文本
    
    case newComing // 用户进房通知
    
    // ...
}

/// 房间消息（原始网络数据）
struct Proto_Room_Nty {
    /// 消息公有数据...
    public var uid: Int = 0 // 消息发送者id
    public var roomId: Int = 0 // 房间id
    public var roomMasterUid: Int // 房主id
    public var contentType = 0 // 消息类型
    public var seq: Int // 消息唯一序列号 (一次直播过程)
    
    /// 不同类型具体消息二进制数据，由 SwiftProtobuf 框架解析
    public var content: Data = Data()
}

/** 以下是遵循SwiftProtobuf相关协议的具体消息结构体 */

struct Proto_Room_NtyOfficialText {
    
    init(serializedData: Data) {
        
    }
}

struct Proto_Room_NtyNewComing {
    init(serializedData: Data) {
        
    }
}

struct Proto_Room_NtyPlainText {
    init(serializedData: Data) {
        
    }
}
