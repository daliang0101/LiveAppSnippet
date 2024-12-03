//
//  ComponentEvenCenter.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/25.
//

import Foundation
import CocoaLumberjack

protocol ComponentEventCenterObserver: AnyObject {
    func eventCenter(_ eventCenter: ComponentEventCenter, receiveEvent event: ComponentEventProtocol)
}

/// 组件事件中心：管理组件之间通信（组件解耦）
class ComponentEventCenter {
    ///
    private class ComponentEventCenterInnerObserver {
        ///
        weak var realObserver: ComponentEventCenterObserver?

        init(observer: ComponentEventCenterObserver?) {
            realObserver = observer
        }
    }

    // 映射表：事件 -> 监听者组件
    private lazy var observerMap: [String: Array<ComponentEventCenterInnerObserver>] = [:]

    // 向监听者组件发送相应事件
    func send(_ event: ComponentEventProtocol) {
        ///
        let eventType = type(of: event)
        ///
        let eventName = String(describing: eventType)

        if let observerList = observerMap[eventName] {
            for observer in observerList {
                observer.realObserver?.eventCenter(self, receiveEvent: event)
                DDLogDebug("[ComponentEventCenter] \(#function) eventName|\(eventName)|realObserver|\(String(describing: observer.realObserver))")
            }
        }
    }

    // 组件向事件中心注册某事件（监听某事件）
    func add(_ observer: ComponentEventCenterObserver, eventClass: AnyClass) {
        ///
        let innerObserver = ComponentEventCenterInnerObserver(observer: observer)
        ///
        let eventName = String(describing: eventClass)

        if let existObserverList = observerMap[eventName] {
            let newObserverList = existObserverList + [innerObserver]
            observerMap[eventName] = newObserverList
        } else {
            var newObserverList: [ComponentEventCenterInnerObserver] = []
            newObserverList.append(innerObserver)

            observerMap[eventName] = newObserverList
        }
    }
}
