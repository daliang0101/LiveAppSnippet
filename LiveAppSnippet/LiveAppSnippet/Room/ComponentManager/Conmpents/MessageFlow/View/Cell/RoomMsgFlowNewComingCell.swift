//
//  RoomMsgFlowNewComingCell.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import SnapKit

class RoomMsgFlowNewComingCell: RoomMsgFlowBaseCell {
    ///
    private lazy var gradientView: GradientLayerView = {
        let g = GradientLayerView()
        g.gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        g.gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        g.gradientLayer.cornerRadius = 8
        g.gradientLayer.colors = [UIColor.hex("#FF408F").cgColor, UIColor.hex("#FFC200").cgColor]
        g.isUserInteractionEnabled = false
        return g
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bgView)
        bgView.addSubview(gradientView)
        bgView.addSubview(textLabel)

        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }

        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(RoomMsgCellUIConfig.textEdgeInsets)
            make.size.equalTo(CGSize.zero)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func bindViewModel(_ viewModel: Any) {
        super.bindViewModel(viewModel)

        // 省略gradientView的显示、隐藏逻辑
        
        textLabel.textLayout = msgFlowVm?.textLayout

        textLabel.snp.updateConstraints { make in
            make.size.equalTo(msgFlowVm?.textLayout?.textBoundingSize ?? .zero)
        }
    }
}
