//
//  BaseCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//
//  From:
//  https://github.com/uptechteam/Coordinator-MVVM-Rx-Example
//  Arthur Myronenko
//  Copyright © 2017 UPTech Team.

import RxSwift

/// Base abstract coordinator generic over the return type of the `start` method.
class BaseCoordinator<ResultType>: Coordinator {

    /// Typealias which will allows to access a ResultType of the Coordainator by `CoordinatorName.CoordinationResult`.
    typealias CoordinationResult = ResultType

    /// Utility `DisposeBag` used by the subclasses.
    let disposeBag = DisposeBag()

    /// Unique identifier.
    internal let identifier = UUID()

    /// Dictionary of the child coordinators. Every child coordinator should be added
    /// to that dictionary in order to keep it in memory.
    /// Key is an `identifier` of the child coordinator and value is the coordinator itself.
    /// Value type is `Any` because Swift doesn't allow to store generic types in the array.
    private var childCoordinators = [UUID: Any]()

    /// Stores coordinator to the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Child coordinator to store.
    private func store<T: Coordinator>(coordinator: T) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    /// Release coordinator from the `childCoordinators` dictionary.
    ///
    /// - Parameter coordinator: Coordinator to release.
    private func free<T: Coordinator>(coordinator: T) {
        childCoordinators[coordinator.identifier] = nil
    }

    /// 1. Stores coordinator in a dictionary of child coordinators.
    /// 2. Calls method `start()` on that coordinator.
    /// 3. On the `onNext:` of returning observable of method `start()` removes coordinator from the dictionary.
    ///
    /// - Parameter coordinator: Coordinator to start.
    /// - Returns: Result of `start()` method.
    func coordinate<T: Coordinator, U>(to coordinator: T) -> Observable<U> where U == T.CoordinationResult {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }

    /// Starts job of the coordinator.
    ///
    /// - Returns: Result of coordinator job.
    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}
