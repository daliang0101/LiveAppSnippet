//
//  ComponentManager.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/25.
//

import Foundation

/// 组件管理者：房间VC向该类注册、注销组件
class ComponentManager {
    ///
    lazy var componentMap: [String: ViewComponentProtocol] = [:]

    lazy var eventCenter: ComponentEventCenter = ComponentEventCenter()

    /** 注册单个组件实例 */
    func registerComponentInstance(_ componentInstance: ViewComponentProtocol, superView: ComponentLayerView?, order: Int) {
        ///
        let componentInstanceType = type(of: componentInstance)
        ///
        let componentInstanceTypeName = String(describing: componentInstanceType)

        if componentInstanceTypeName.isEmpty {
            return
        }

        /** 过滤模块是否已经被注册 */
        if componentMap[componentInstanceTypeName] != nil {
            return
        }

        /** 添加到modules中 */

        componentInstance.componentInit()

        componentInstance.superView = superView
        componentInstance.order = order
        componentInstance.eventCenter = eventCenter

        componentInstanceWillRegisted(componentInstance)
        componentInstance.componentDidRegisted()

        componentMap[componentInstanceTypeName] = componentInstance
    }

    /** 注销单个模块 */
    func unRegisterComponent(_ componentClass: AnyClass) {
        ///
        let componentInstanceTypeName = String(describing: componentClass)
        if let instance = componentMap[componentInstanceTypeName] {
            instance.componentWillUnRegister()
        }
        componentMap.removeValue(forKey: componentInstanceTypeName)
    }

    /** 注销所有模块 */
    func unRegisterAllComponent() {
        ///
        for value in componentMap.values {
            value.componentWillUnRegister()
        }
        componentMap.removeAll()
    }

    /** 即将完成注册 ,子类复写该方法用于组件属性赋值 */
    func componentInstanceWillRegisted(_ instance: ViewComponentProtocol) {
        ///
    }
}

extension ComponentManager {
    ///
    func viewDidLoad() {
        for observer in componentMap.values {
            observer.viewDidLoad()
        }
    }

    func viewWillAppear(_ animated: Bool) {
        for observer in componentMap.values {
            observer.viewWillAppear(animated)
        }
    }

    func viewWillLayoutSubviews() {
        for observer in componentMap.values {
            observer.viewWillLayoutSubviews()
        }
    }

    func viewDidLayoutSubviews() {
        for observer in componentMap.values {
            observer.viewDidLayoutSubviews()
        }
    }

    func viewDidAppear(_ animated: Bool) {
        for observer in componentMap.values {
            observer.viewDidAppear(animated)
        }
    }

    func viewWillDisappear(_ animated: Bool) {
        for observer in componentMap.values {
            observer.viewWillDisappear(animated)
        }
    }

    func viewDidDisappear(_ animated: Bool) {
        for observer in componentMap.values {
            observer.viewDidDisappear(animated)
        }
    }
}
