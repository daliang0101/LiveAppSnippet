//
//  RoomContentViewController.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/25.
//

import Foundation
import UIKit

class RoomContentViewController: UIViewController, ComponentEventCenterObserver {
    lazy var componentManager: RoomComponentManager = {
        let rc = RoomComponentManager()
        return rc
    }()
    
    /// 多媒体区
    private lazy var mediaLayerView: ComponentLayerView = {
        let v = ComponentLayerView(frame: view.bounds)
        return v
    }()

    /// 基础组件区
    private lazy var baseLayerView: ComponentLayerView = {
        let v = ComponentLayerView(frame: view.bounds)
        return v
    }()
    
    // MARK: - lifecycle

    deinit {
        componentManager.unRegisterAllComponent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear

        addLayerView() // 添加各区域组件的父视图
        registerComponents() // 添加组件
        registerEvent() // 注册组件 通知事件
        componentManager.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        componentManager.viewWillAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        componentManager.viewWillLayoutSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        componentManager.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        componentManager.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        componentManager.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        componentManager.viewDidDisappear(animated)
    }
    
    // MARK: - Setup

    private func addLayerView() {
        view.addSubview(mediaLayerView)
        view.addSubview(baseLayerView)
    }

    private func registerComponents() {
        componentManager.roomViewController = self
        
        // 消息流组件
        componentManager.registerComponentInstance(RoomMsgFlowComponent(), superView: baseLayerView, order: RoomComponentBaseOrder.msgFlow.rawValue)
        
        // 麦位组件
//        componentManager.registerComponentInstance(RoomMicSeatComponent(), superView: mediaLayerView, order: RoomComponentMediaOrder.micSeat.rawValue)
        
        // ...
    }
    
    private func registerEvent() {
//        componentManager.eventCenter.add(self, eventClass: RoomExitRoomEvent.self)
    }
    
    func eventCenter(_ eventCenter: ComponentEventCenter, receiveEvent event: any ComponentEventProtocol) {
        
    }
}
