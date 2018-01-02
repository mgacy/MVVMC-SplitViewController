//
//  TodosCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxSwift

class TodosCoordinator: BaseCoordinator<Void> {

    private let navigationController: UINavigationController
    private let client: APIClient

    init(navigationController: UINavigationController, client: APIClient) {
        self.navigationController = navigationController
        self.client = client
    }

    override func start() -> Observable<Void> {
        var viewController = TodosListViewController.instance()
        navigationController.viewControllers = [viewController]

        var avm: Attachable<TodosListViewModel> = .detached(TodosListViewModel.Dependency(client: client))
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
