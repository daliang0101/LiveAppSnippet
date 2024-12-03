//
//  GradientLayerView.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import UIKit

public class GradientLayerView: UIView {
    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    public var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }

    public var gradientPoints: [CGPoint]? {
        didSet {
            let startPoint = gradientPoints?.first
            let endPoint = gradientPoints?.last
            gradientLayer.startPoint = startPoint ?? CGPoint.zero
            gradientLayer.endPoint = endPoint ?? CGPoint.zero
        }
    }

    public var colors: [UIColor]? {
        didSet {
            gradientLayer.colors = colors?.map({ $0.cgColor })
        }
    }

    public var autoAdjustArabicColors: [UIColor]? {
        get {
            return colors
        }
        set {
            var adjustColors: [UIColor]? = newValue
            adjustColors = UIView.RTL() ? adjustColors?.reversed() : adjustColors
            colors = adjustColors
        }
    }
}
