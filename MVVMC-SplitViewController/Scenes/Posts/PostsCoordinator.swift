//
//  PostsCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxSwift

class PostsCoordinator: BaseCoordinator<Void> {

    private let navigationController: UINavigationController
    private let client: APIClient

    init(navigationController: UINavigationController, client: APIClient) {
        self.navigationController = navigationController
        self.client = client
    }

    override func start() -> Observable<Void> {
        var viewController = PostsListViewController.instance()
        navigationController.viewControllers = [viewController]

        var avm: Attachable<PostsListViewModel> = .detached(PostsListViewModel.Dependency(client: client))
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
