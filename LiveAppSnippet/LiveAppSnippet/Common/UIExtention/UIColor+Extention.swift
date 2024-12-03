//
//  UIColor+Extention.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import UIKit

extension UIColor {
    static func hex(_ hexString: String, alpha: Double = 1.0) -> UIColor {
        return UIColor(hexString, alpha: alpha)
    }
    
    /**
     UIColor with hex string
     
     - parameter hexString: #000000
     - parameter alpha:     alpha value
     
     - returns: UIColor
     */
    convenience init(_ hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
    }
}

