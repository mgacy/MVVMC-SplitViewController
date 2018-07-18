//
//  TodosCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxSwift

class TodosCoordinator: BaseCoordinator<Void> {
    typealias Dependencies = HasTodoService

    private let navigationController: UINavigationController
    private let dependencies: Dependencies

    init(navigationController: UINavigationController, dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    override func start() -> Observable<Void> {
        let viewController = TodosListViewController.instance()
        navigationController.viewControllers = [viewController]

        let avm: Attachable<TodosListViewModel> = .detached(dependencies)
        let viewModel = viewController.attach(wrapper: avm)

        viewModel.selectedTodo
            .drive(onNext: { selection in
                print("Selected: \(selection)")
            })
            .disposed(by: viewController.disposeBag)

        // View will never be dismissed
        return Observable.never()
    }

}
