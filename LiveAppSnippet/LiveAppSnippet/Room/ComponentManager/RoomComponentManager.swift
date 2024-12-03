//
//  RoomComponentManager.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/25.
//

import Foundation
import UIKit

/// 房间组件管理者
class RoomComponentManager: ComponentManager {

    weak var roomViewController: UIViewController? {
        didSet {
            for observer in componentMap.values {
                observer.superViewController = roomViewController
            }
        }
    }

    weak var liveService: RoomLiveService? {
        didSet {
            for observer in componentMap.values {
                if let roomObserver = observer as? RoomComponentProtocol {
                    roomObserver.liveService = liveService
                }
            }
        }
    }

    weak var webService: RoomWebService? {
        didSet {
            for observer in componentMap.values {
                if let roomObserver = observer as? RoomComponentProtocol {
                    roomObserver.webService = webService
                }
            }
        }
    }

    weak var fullModel: RoomFullModel? {
        didSet {
            for observer in componentMap.values {
                if let roomObserver = observer as? RoomComponentProtocol {
                    roomObserver.fullModel = fullModel
                    //重连等情况下会更新LiveModel，相关组件可通过此方法更新展示
                    roomObserver.componentDidUpdateFullModel()
                }
            }
        }
    }

    ///
    override func componentInstanceWillRegisted(_ instance: ViewComponentProtocol) {
        if let roomInstance = instance as? RoomComponentProtocol {
            ///
            roomInstance.superViewController = roomViewController
            roomInstance.liveService = liveService
            roomInstance.webService = webService
            roomInstance.fullModel = fullModel
        }
    }
}
