//
//  RoomMsgFlowPlainTextCell.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import SnapKit

class RoomMsgFlowPlainTextCell: RoomMsgFlowBaseCell {
    // 头像、用户名、标签、VIP、...
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // contentView.addSubview(avatarView)
        // ...
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
        
        // 省略 其他子视图显示、隐藏、内容赋值
        
    }
}

