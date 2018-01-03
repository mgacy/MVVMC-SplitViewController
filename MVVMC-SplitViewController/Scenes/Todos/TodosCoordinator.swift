//
//  TodosCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxSwift

class TodosCoordinator: BaseCoordinator<Void> {
    typealias Dependencies = HasClient

    private let navigationController: UINavigationController
    private let depedencies: Dependencies

    init(navigationController: UINavigationController, dependencies: Dependencies) {
        self.navigationController = navigationController
        self.depedencies = dependencies
    }

    override func start() -> Observable<Void> {
        var viewController = TodosListViewController.instance()
        navigationController.viewControllers = [viewController]

        var avm: Attachable<TodosListViewModel> = .detached(TodosListViewModel.Dependency(client: depedencies.client))
        let viewModel = viewController.bind(toViewModel: &avm)

        viewModel.selectedTodo
            .drive(onNext: { selection in
                print("Selected: \(selection)")
            })
            .disposed(by: viewController.disposeBag)

        // View will never be dismissed
        return Observable.never()
    }

}
