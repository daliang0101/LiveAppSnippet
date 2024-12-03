//
//  RoomMsgFlowComponent.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/29.
//

import Foundation
import DequeModule
import RxSwift
import RxCocoa
import IGListKit

class RoomMsgFlowComponent: RoomComponent {
    private enum FlowConstants {
        static let maxCount: Int = 500 // 列表最多展示消息数量(最新的)
        static let subtractCount: Int = 50 // 增量操作之后，若超过500条，则取最新的 500-50 条
        static let maxIncrementCount: Int = 5 // 列表数据量每次(刷新后)增量最大值
        static let refreshInterval: Int = 600 // 定时刷新时间间隔(毫秒)
    }
    
    private var cachedMessages = Deque<RoomWebMessage>() // 从webService接受的消息
    private var msgFlowVmList: [RoomMessageFlowViewModel] = [] // 消息列表视图数据源
    
    private lazy var adapter: ListAdapter = .init(updater: ListAdapterUpdater(), viewController: nil)
    
    private lazy var containerView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        v.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        v.backgroundColor = UIColor.clear
        v.alwaysBounceVertical = true
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.contentInsetAdjustmentBehavior = .never
        v.delaysContentTouches = false
        return v
    }()
    
    // MARK: - ViewComponentProtocol

    override func componentDidRegisted() {
        /// 注册所需的web通知型消息
        webService?.addObserver(self, messageTypes: [.officalText, .newComing, .plainText])
        
        /// 注册来自其他组件的通知事件
        eventCenter?.add(self, eventClass: RoomKeyboardChangedEvent.self)
        /// ...
    }
    
    // MARK: - ViewControllerLifecycleProtocol

    override func viewDidLoad() {
        /// 创建消息流区域视图（省略约束设置）
        superView?.insert(containerView, at: order)
        containerView.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        // 定时检测是否有新消息到来、更新视图
        Driver<Int>.interval(.milliseconds(FlowConstants.refreshInterval)).drive { [weak self] _ in
            self?.updateMessageShow()
        }.disposed(by: rx.disposeBag)
    }
    
    // MARK: - ComponentEventCenterObserver
    override func eventCenter(_ eventCenter: ComponentEventCenter, receiveEvent event: any ComponentEventProtocol) {
        if let event = event as? RoomKeyboardChangedEvent {
            /// 根据键盘事件相关属性，调整消息流视图区域的位置布局、配以适合的动效
            return
        }
    }
    
}

// MARK: - RoomWebObserverProtocol
extension RoomMsgFlowComponent: RoomWebObserverProtocol {
    func roomWebServiceReceiveMessage(_ message: RoomWebMessage) {
        /// 过滤逻辑...
        
        cachedMessages.append(message)
    }
}

// MARK: - Private methods
extension RoomMsgFlowComponent {
    private func updateMessageShow() {
        var msgs = [RoomWebMessage]()
        
        while !cachedMessages.isEmpty, msgs.count < FlowConstants.maxIncrementCount {
            msgs.append(cachedMessages.popFirst()!)
        }
        
        // 这里只简单转换，实际项目中会有一些过滤逻辑
        let incrementFlowVmList = msgs.map { RoomMessageFlowViewModel(message: $0) }
        guard !incrementFlowVmList.isEmpty else {
            return
        }
        
        DispatchQueue.global(qos: .default).async {
            // 异步计算YYTextLayout
            incrementFlowVmList.forEach {$0.generateTextLayout()}
            
            DispatchQueue.main.async {
                self.msgFlowVmList.append(contentsOf: incrementFlowVmList)
                if self.msgFlowVmList.count > FlowConstants.maxCount {
                    self.msgFlowVmList = Array(self.msgFlowVmList.suffix(FlowConstants.maxCount - FlowConstants.subtractCount))
                }
                
                self.adapter.performUpdates(animated: true) { _ in
                    self.scrollToBottom() // 省略自动滚动到底部、展示未读消息数量提示 的逻辑
                }
            }
        }
    }
    
    @objc private func scrollToBottom() {
        guard let last = msgFlowVmList.last else { return }
        adapter.scroll(to: last, supplementaryKinds: nil, scrollDirection: .vertical, scrollPosition: .bottom, animated: true)
    }
    
    /// cell点击事件
    private func handleHighlight(_ userInfo: [AnyHashable: Any]) {}
    private func handleLongTapAvatar(_ userInfo: [AnyHashable: Any]) {}
    private func handleTapMsgFlowModel(_ model: RoomMessageFlowViewModel) {}
}

// MARK: - ListAdapterDataSource
extension RoomMsgFlowComponent: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return msgFlowVmList
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = RoomMsgFlowSectionController()
        sectionController.tapHighlightAction = { [weak self] userInfo in
            self?.handleHighlight(userInfo)
        }

        sectionController.longTapAvatarAction = { [weak self] userInfo in
            self?.handleLongTapAvatar(userInfo)
        }
        sectionController.tapCellAction = { [weak self] model in
            self?.handleTapMsgFlowModel(model)
        }
        return sectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
