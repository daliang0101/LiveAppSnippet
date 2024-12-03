//
//  RoomMsgCellUIConfig.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import Foundation
import UIKit

struct RoomMsgCellUIConfig {
    ///
    static let containerWidth: CGFloat = PointAdapt(285)
    ///
    static let textEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ///
    static let officialTextMaxWidth = containerWidth - textEdgeInsets.left - textEdgeInsets.right
}
