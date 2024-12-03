//
//  RoomWebService.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import Foundation
import CocoaLumberjack

class RoomWebService: NSObject {
    private let tcpApi = WebTcpApi()
    
    private(set) var roomFullModel: RoomFullModel? // 房间全量数据
    
    /// 房间消息监听者：如消息流展示组件
    private var messageObservers: [RoomWebMessageType: RoomWebObservers] = [:]
    
    override init() {
        super.init()
        listenTCPEvent()
    }

    deinit {
        messageObservers.removeAll()
        stopListenTCPEvent()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func listenTCPEvent() {
        /// 监听连接状态...
        
        /// 监听房间消息
        tcpApi.addRoomObserverOnNtyMessage(target: self) { [weak self] ntyMsg in
            guard let msg = ntyMsg else { return }
            self?.onReceiveRoomNtyMsg(msg)
        }
    }
    private func stopListenTCPEvent() {
        tcpApi.removeObserverOnNtyMessage(target: self)
    }
    
    private func onReceiveRoomNtyMsg(_ notify: Proto_Room_Nty) {
        let message = RoomWebMessage(nty: notify) // 网络数据转成App数据模型
        DDLogInfo("[VoiceRoom-Web] receiveRoomNtyMsg|type:\(message.type)|contentType:\(notify.contentType)")

        // ...

        guard let observers = messageObservers[message.type] else { return }
        observers.rawObservers.forEach { observer in
            observer.roomWebServiceReceiveMessage(message)
        }
    }
    
    /// 添加房间Notify消息的监听者
    func addObserver(_ observer: RoomWebObserverProtocol, messageTypes: [RoomWebMessageType]) {
        for type in messageTypes {
            let obsList = messageObservers[type] ?? RoomWebObservers()
            obsList.add(observer: observer)
            messageObservers[type] = obsList
        }
    }
    
}

// MARK: - 进出房
extension RoomWebService {
    /// 普通方式进房
    func enterRoom(uid: Int, roomId: Int, password: String? = nil, completion: ((_ errorCode: Int?, _ enterFullModel: RoomFullModel?) -> Void)?) {
        // tcpApi.enterRoom
    }
    
    /// 创建房间后进房
    func enterRoom(uid: Int, metaData: RoomMetaData, completion: ((_ errorCode: Int?, _ enterFullModel: RoomFullModel?) -> Void)?) {
        
    }
    
    /// 退出房间
    func exitRoom() {
        
    }
}

// MARK: - 麦位

// MARK: - 礼物

// MARK: - 历史消息、观众列表、发送消息

// MARK: - 更新房间元数据、锁房、解锁

// MARK: - PK

// MARK: - BigEmotion(麦位表情)
