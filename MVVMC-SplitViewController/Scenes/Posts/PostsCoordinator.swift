//
//  PostsCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxSwift

class PostsCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    private let client: APIClient

    init(window: UIWindow) {
        self.window = window
        self.client = APIClient()
    }

    override func start() -> Observable<Void> {
        var viewController = PostsListViewController.instance()
        let navigationController = UINavigationController(rootViewController: viewController)

        var avm: Attachable<PostsListViewModel> = .detached(PostsListViewModel.Dependency(client: client))
        let viewModel = viewController.bind(toViewModel: &avm)

        // Navigation (eventually)
        viewModel.selectedPost
            .drive(onNext: { selection in
                print("Selected: \(selection)")
            })
            .disposed(by: viewController.disposeBag)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        // View will never be dismissed
        return Observable.never()
    }

}
