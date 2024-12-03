//
//  RoomViewController.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/25.
//

import Foundation
import UIKit
import CocoaLumberjack

class RoomViewController: UIViewController {
    private var uid: Int = 0
    private var roomId: Int = 0
    
    private var liveService = RoomLiveService(roomType: .VoiceRoom)
    private var webService = RoomWebService()
    private var roomFullModel: RoomFullModel?
    
    private lazy var contentVC: RoomContentViewController = {
        let vc = RoomContentViewController()
        return vc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRoomService()
        startRoomService()
    }
    
    // MARK: - Private methods
    
    private func setupRoomService() {
        
    }
    
    private func startRoomService() {
        webService.enterRoom(uid: uid, roomId: roomId) { [weak self] errorCode, enterFullModel in
            guard let self = self else { return }
            if let model = enterFullModel {
                DDLogInfo("[VoiceRoom] enter room succeed, roomId:\(roomId)|uid:\(uid)")
                roomFullModel = enterFullModel
                joinRoom(channelName: model.channelName)
                addRoomContentVC()
            }
//            if let err = errorCode {
//
//            }
        }
    }
    
    private func addRoomContentVC() {
        contentVC.componentManager.fullModel = roomFullModel
        contentVC.componentManager.liveService = liveService
        contentVC.componentManager.webService = webService
        addChild(contentVC)
        view.addSubview(contentVC.view)
    }
    
    private func joinRoom(channelName: String) {
        liveService.micSeatList = roomFullModel?.micSeatList ?? []
        liveService.joinChannel(name: channelName)
    }
    
    // MARK: - Public methods
    static func enterRoom(uid: Int, roomId: Int) -> RoomViewController {
        let roomVC = RoomViewController()
        roomVC.uid = uid
        roomVC.roomId = roomId
        return roomVC
    }
    
}
