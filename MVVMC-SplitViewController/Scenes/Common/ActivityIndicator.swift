//
//  ActivityIndicator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//
//  From:
//  https://github.com/ReactiveX/RxSwift
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import RxSwift
import RxCocoa

// swiftlint:disable identifier_name
// swiftlint:disable multiple_closures_with_trailing_closure
// swiftlint:disable type_name

private struct ActivityToken<E>: ObservableConvertibleType, Disposable {
    private let _source: Observable<E>
    private let _dispose: Cancelable

    init(source: Observable<E>, disposeAction: @escaping () -> Void) {
        _source = source
        _dispose = Disposables.create(with: disposeAction)
    }

    func dispose() {
        _dispose.dispose()
    }

    func asObservable() -> Observable<E> {
        return _source
    }
}

/**
 Enables monitoring of sequence computation.

 If there is at least one sequence computation in progress, `true` will be sent.
 When all activities complete `false` will be sent.
 */
public class ActivityIndicator: SharedSequenceConvertibleType {
    public typealias E = Bool
    public typealias SharingStrategy = DriverSharingStrategy

    private let _lock = NSRecursiveLock()
    private let _variable = Variable(0)
    private let _loading: SharedSequence<SharingStrategy, Bool>

    public init() {
        _loading = _variable.asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return Observable.using({ () -> ActivityToken<O.E> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: self.decrement)
        }) { t in
            return t.asObservable()
        }
    }

    private func increment() {
        _lock.lock()
        _variable.value += 1
        _lock.unlock()
    }

    private func decrement() {
        _lock.lock()
        _variable.value -= 1
        _lock.unlock()
    }

    public func asSharedSequence() -> SharedSequence<SharingStrategy, E> {
        return _loading
    }
}

extension ObservableConvertibleType {
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<E> {
        return activityIndicator.trackActivityOfObservable(self)
    }
}
