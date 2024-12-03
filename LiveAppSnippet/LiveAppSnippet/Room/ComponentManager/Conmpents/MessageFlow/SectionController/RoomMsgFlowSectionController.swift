//
//  RoomMsgFlowSectionController.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/12/1.
//

import IGListKit

class RoomMsgFlowSectionController: ListSectionController {
    ///
    var object: RoomMessageFlowViewModel!

    var tapHighlightAction: (([AnyHashable: Any]) -> Void)?

    var longTapAvatarAction: (([AnyHashable: Any]) -> Void)?

    var tapCellAction: ((RoomMessageFlowViewModel) -> Void)?

    override init() {
        super.init()

        inset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: object.cellHeight)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass: AnyClass
        switch object.type {
        case .officalText:
            cellClass = RoomMsgFlowOfficialCell.self
        case .plainText:
            cellClass = RoomMsgFlowPlainTextCell.self
        case .newComing:
            cellClass = RoomMsgFlowNewComingCell.self
        case .Unknown:
            cellClass = RoomMsgFlowBaseCell.self
        }
        guard let cell = collectionContext?.dequeueReusableCell(of: cellClass, for: self, at: index) as? RoomMsgFlowBaseCell else {
            fatalError()
        }
        cell.bindViewModel(object!)
        cell.tapHighlightAction = { [weak self] userInfo in
            self?.tapHighlightAction?(userInfo)
        }
        cell.longTapAvatarAction = { [weak self] userInfo in
            self?.longTapAvatarAction?(userInfo)
        }
        return cell
    }

    override func didUpdate(to object: Any) {
        precondition(object is RoomMessageFlowViewModel)
        self.object = object as? RoomMessageFlowViewModel
    }

    override func didSelectItem(at index: Int) {
        tapCellAction?(object)
    }
}
