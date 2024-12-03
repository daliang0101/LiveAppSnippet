//
//  RoomKeyboardChangedEvent.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import Foundation
import UIKit

/// 键盘弹出、收起
final class RoomKeyboardChangedEvent: ComponentEventProtocol {
    ///
    var isShow: Bool = false

    var height: CGFloat = 0

    var duration: TimeInterval = 0

    var animationOptions: UIView.AnimationOptions = .curveLinear
}
