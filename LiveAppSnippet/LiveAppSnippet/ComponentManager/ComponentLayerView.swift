//
//  ComponentLayerView.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/25.
//

import UIKit

/// 组件父视图：由组件业务属性的不同， 定义不同的父视图
class ComponentLayerView: UIView {
    ///
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func insert(_ view: UIView, at index: Int) {
        view.tag = index
        if subviews.isEmpty {
            addSubview(view)
        } else {
            for i in 0 ..< subviews.count {
                let obj = subviews[i]
                if obj.tag > index {
                    insertSubview(view, belowSubview: obj)
                    break
                } else if i == subviews.count - 1 {
                    addSubview(view)
                    break
                }
            }
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitTestView = super.hitTest(point, with: event)
        if hitTestView == self {
            return nil
        }
        return hitTestView
    }
}
