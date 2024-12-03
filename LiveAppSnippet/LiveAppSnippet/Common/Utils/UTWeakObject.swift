//
//  UTWeakObject.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import Foundation

public protocol UTWeakObserver: AnyObject {
    associatedtype T
    var weakObservers: Array<UTWeakObject<AnyObject>> { get set }
    var rawObservers: Array<T> { get }
    func add(observer: T)
    func remove(observer: T)
}

public extension UTWeakObserver {
    var rawObservers: Array<T> {
        return weakObservers.filter({
            $0.object != nil
        }).map { $0.object as! T }
    }

    func add(observer: T) {
        let weak = UTWeakObject(observer as AnyObject)
        if weakObservers.contains(weak) { return }
        weakObservers.append(weak)
    }

    func remove(observer: T) {
        // observer.deint remove, WeakObject 中已经置空
        weakObservers.removeAll {
            $0.object === observer as AnyObject || $0.object == nil
        }
    }

    func insertAtFirst(observer: T) {
        let weak = UTWeakObject(observer as AnyObject)

        if let index = weakObservers.firstIndex(of: weak) {
            weakObservers.remove(at: index)
        }
        weakObservers.insert(weak, at: 0)
    }
}

/**
 1. WeakObject.object  会在object.deint 时就已经置空
  2. object deint中 初始化会异常, weak 表已经执行过了, 不可以再被weak 赋值
 */
public class UTWeakObject<T: AnyObject>: Equatable, Hashable {
    // object deint中 初始化会异常
    private(set) weak var object: T?

    required init(_ object: T?) {
        self.object = object
    }

    public func hash(into hasher: inout Hasher) {
        // https://forums.swift.org/t/hashing-weak-variables/31345/8
        hasher.combine(object.map(ObjectIdentifier.init))
    }

    public static func == (lhs: UTWeakObject<T>, rhs: UTWeakObject<T>) -> Bool {
        return lhs.object === rhs.object
    }

    var hashString: String {
        return String(format: "%016X -%016X", hashValue, object.map(ObjectIdentifier.init).hashValue)
    }
}
