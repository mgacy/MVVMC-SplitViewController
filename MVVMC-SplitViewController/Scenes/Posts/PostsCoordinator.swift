//
//  PostsCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxSwift

class PostsCoordinator: BaseCoordinator<Void> {
    typealias Dependencies = HasClient

    private let navigationController: UINavigationController
    private let dependencies: Dependencies

    init(navigationController: UINavigationController, dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    override func start() -> Observable<Void> {
        var viewController = PostsListViewController.instance()
        navigationController.viewControllers = [viewController]

        var avm: Attachable<PostsListViewModel> = .detached(dependencies)
        let viewModel = viewController.bind(toViewModel: &avm)

        viewModel.selectedPost
            .drive(onNext: { [weak self] selection in
                self?.showDetailView(with: selection)
            })
            .disposed(by: viewController.disposeBag)

        // View will never be dismissed
        return Observable.never()
    }

    private func showDetailView(with post: Post) {
        let viewController = PostDetailViewController.instance()
        viewController.viewModel = PostDetailViewModel(post: post)
        navigationController.pushViewController(viewController, animated: true)
    }

}
