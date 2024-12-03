//
//  UIView+Extention.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import UIKit

extension UIView {
    class func RTL() -> Bool {
        return UIView.appearance().semanticContentAttribute == .forceRightToLeft
    }
}
