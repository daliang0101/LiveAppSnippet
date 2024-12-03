//
//  RoomMsgFlowOfficialCell.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import SnapKit

class RoomMsgFlowOfficialCell: RoomMsgFlowBaseCell {
    ///
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(bgView)
        bgView.addSubview(textLabel)

        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
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
        
        textLabel.textLayout = msgFlowVm?.textLayout

        textLabel.snp.updateConstraints { make in
            make.size.equalTo(msgFlowVm?.textLayout?.textBoundingSize ?? .zero)
        }
    }
}
