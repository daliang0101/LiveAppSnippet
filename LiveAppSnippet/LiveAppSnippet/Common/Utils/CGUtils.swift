//
//  CGUtils.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import Foundation
import UIKit

fileprivate var scale: CGFloat = {
    var scale = UIScreen.main.scale
    return scale
}()

fileprivate var size: CGSize = {
    var size = UIScreen.main.bounds.size
    if size.height < size.width {
        let tmp = size.height
        size.height = size.width
        size.width = tmp
    }
    return size
}()

public func ScreenScale() -> CGFloat {
    return scale
}

public func ScreenSize() -> CGSize {
    return size
}

public func PointPixelFloor(_ value: CGFloat) -> CGFloat {
    let scale = ScreenScale()
    return floor(value * scale) / scale
}

public func PointAdapt(_ value: CGFloat) -> CGFloat {
    return PointPixelFloor(value * ScreenSize().width / 375.0)
}
