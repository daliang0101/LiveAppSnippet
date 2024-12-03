//
//  RoomMsgFlowBaseCell.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import IGListKit
import YYText

class RoomMsgFlowBaseCell: UICollectionViewCell, ListBindable {
    
    lazy var bgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        v.layer.cornerRadius = 8
        return v
    }()

    lazy var textLabel: YYLabel = {
        let label = YYLabel()
        label.displaysAsynchronously = true
        label.ignoreCommonProperties = true
        label.highlightTapAction = { [weak self] _, _, range, _ in
            self?.handleHighlightTap(textRange: range)
        }
        return label
    }()
    
    var tapHighlightAction: (([AnyHashable: Any]) -> Void)?
    var longTapAvatarAction: (([AnyHashable: Any]) -> Void)?
    
    internal var msgFlowVm: RoomMessageFlowViewModel?
    
    func bindViewModel(_ viewModel: Any) {
        guard let viewModel = viewModel as? RoomMessageFlowViewModel else { return }
        msgFlowVm = viewModel
    }
    
    func handleHighlightTap(textRange: NSRange) {
        //
        guard let text = textLabel.textLayout?.text else { return }

        guard textRange.location < text.length else { return }

        guard let highlight = text.yy_attribute(YYTextHighlightAttributeName, at: UInt(textRange.location)) as? YYTextHighlight else { return }

        if let userInfo = highlight.userInfo {
            tapHighlightAction?(userInfo)
        }
    }
}
