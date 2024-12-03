//
//  ComponentProtocol.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/25.
//

import Foundation
import UIKit

protocol ViewControllerLifecycleProtocol: AnyObject {
    ///
    func viewDidLoad()

    func viewWillAppear(_ animated: Bool)

    func viewWillLayoutSubviews()

    func viewDidLayoutSubviews()

    func viewDidAppear(_ animated: Bool)

    func viewWillDisappear(_ animated: Bool)

    func viewDidDisappear(_ animated: Bool)
}

protocol ViewComponentProtocol: ViewControllerLifecycleProtocol {
    /** 初始化,此时没有组件基本属性 */
    func componentInit()

    /** 模块完成注册后调用，实现的属性全设置完成 */
    func componentDidRegisted()

    /** 模块被注销前会调用 */
    func componentWillUnRegister()

    var order: Int { get set }

    var superViewController: UIViewController? { get set }

    var superView: ComponentLayerView? { get set }

    var eventCenter: ComponentEventCenter? { get set }
}

protocol ComponentEventProtocol: AnyObject {
    ///
}
