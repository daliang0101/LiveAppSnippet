//
//  RoomMessageFlowViewModel.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import YYText
import IGListDiffKit

class RoomMessageFlowViewModel {
    private let msg: RoomWebMessage
    
    /// 由相应类型cel的l展示逻辑 生成的属性字符串
    private let attributedText: NSAttributedString
    
    var textLayout: YYTextLayout?
    
    init(message: RoomWebMessage) {
        self.msg = message
        
        var resultAttrStr = NSMutableAttributedString()
        
        switch message.type {
        case .officalText:
            // resultAttrStr.append(xxx)
            print()
        case .newComing:
            // resultAttrStr.append(xxx)
            print()
        case .plainText:
            // resultAttrStr.append(xxx)
            print()
        case .Unknown:
            print("---Unknown---")
        }
        
        attributedText = resultAttrStr
    }
    
    func generateTextLayout() {
        let container = YYTextContainer()
        
        switch msg.type {
        case .officalText:
//            container.size = CGSize(width: FlowUIConfig.officialMaxWidth, height: CGFloat.greatestFiniteMagnitude)
            container.maximumNumberOfRows = 0
            print()
        case .newComing:
            container.maximumNumberOfRows = 0
        case .plainText:
            container.maximumNumberOfRows = 0
        case .Unknown:
            container.maximumNumberOfRows = 0
        }
        
        textLayout = YYTextLayout(container: container, text: attributedText)
    }
    
    /// 文本size + 微调，得到该类型消息的cell高度
    var cellHeight: CGFloat {
        switch msg.type {
        case .officalText:
            return (textLayout?.textBoundingSize.height ?? 0) // + FlowCellUIAdjustment.officialCellHeight
        case .newComing:
            return (textLayout?.textBoundingSize.height ?? 0) // + FlowCellUIAdjustment.newCommingCellHeight
        case .plainText:
            return (textLayout?.textBoundingSize.height ?? 0) // + FlowCellUIAdjustment.plainTextCellHeight
        case .Unknown:
            return (textLayout?.textBoundingSize.height ?? 0) // + FlowCellUIAdjustment.unknowCellHeight
        }
    }
    
    var type: RoomWebMessageType {
        msg.type
    }
}

extension RoomMessageFlowViewModel: ListDiffable {
    ///
    func diffIdentifier() -> NSObjectProtocol {
        return msg.seq as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let item = object as? RoomMessageFlowViewModel else { return false }
        return msg.seq == item.msg.seq && msg.type == item.msg.type
    }
}
