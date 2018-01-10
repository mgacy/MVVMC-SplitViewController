//
//  AlbumsCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/9/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxSwift

class AlbumsCoordinator: BaseCoordinator<Void> {
    typealias Dependencies = HasClient

    private let navigationController: UINavigationController
    private let dependencies: Dependencies

    init(navigationController: UINavigationController, dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    override func start() -> Observable<Void> {
        let viewController = AlbumListViewController.instance()
        navigationController.viewControllers = [viewController]

        let avm: Attachable<AlbumListViewModel> = .detached(dependencies)
        let viewModel = viewController.attach(wrapper: avm)

        viewModel.selectedAlbum
            .drive(onNext: { selection in
                print("Selected: \(selection)")
            })
            .disposed(by: viewController.disposeBag)


        // View will never be dismissed
        return Observable.never()
    }

    private func showDetailView(with post: Post) {
        let viewController = PostDetailViewController.instance()
        viewController.viewModel = PostDetailViewModel(post: post)
        navigationController.showDetailViewController(viewController, sender: nil)
    }

}

