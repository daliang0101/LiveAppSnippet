//
//  RoomComponentProtocol.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/25.
//

import Foundation
import UIKit

/// 房间组件协议：定义最基本的公有属性、方法
protocol RoomComponentProtocol: ViewComponentProtocol {
    ///
    var liveService: RoomLiveService? { get set }
    ///
    var webService: RoomWebService? { get set }
    ///
    var fullModel: RoomFullModel? { get set }
    
    func componentDidUpdateFullModel()
}

/// 房间组件基类
class RoomComponent: NSObject, RoomComponentProtocol, ComponentEventCenterObserver {

    // MARK: RoomComponentProtocol

    weak var liveService: RoomLiveService?

    weak var webService: RoomWebService?

    weak var fullModel: RoomFullModel?
    
    func componentDidUpdateFullModel() {
        ///
    }

    // MARK: - ViewComponentProtocol

    var order: Int = 0

    weak var superViewController: UIViewController?

    weak var superView: ComponentLayerView?

    weak var eventCenter: ComponentEventCenter?

    func componentInit() {
        ///
    }

    func componentDidRegisted() {
        ///
    }

    func componentWillUnRegister() {
        ///
    }

    // MARK: - ViewControllerLifecycleProtocol

    func viewDidLoad() {
        ///
    }

    func viewWillAppear(_ animated: Bool) {
        ///
    }

    func viewWillLayoutSubviews() {
        ///
    }

    func viewDidLayoutSubviews() {
        ///
    }

    func viewDidAppear(_ animated: Bool) {
        ///
    }

    func viewWillDisappear(_ animated: Bool) {
        ///
    }

    func viewDidDisappear(_ animated: Bool) {
        ///
    }

    // MARK: - ComponentEventCenterObserver

    func eventCenter(_ eventCenter: ComponentEventCenter, receiveEvent event: ComponentEventProtocol) {
        ///
    }
    
    
}
