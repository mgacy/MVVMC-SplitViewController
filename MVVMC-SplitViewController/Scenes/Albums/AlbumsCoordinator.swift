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
            .drive(onNext: { [weak self] selection in
                self?.showDetailView(with: selection)
            })
            .disposed(by: viewController.disposeBag)

        // View will never be dismissed
        return Observable.never()
    }

    private func showDetailView(with album: Album) {
        let viewController = PhotoCollectionViewController.instance()
        let avm: Attachable<PhotoCollectionViewModel> = .detached(PhotoCollectionViewModel.Dependency(
            client: dependencies.client, album: album))
        let viewModel = viewController.attach(wrapper: avm)

        navigationController.pushViewController(viewController, animated: true)

        viewModel.selectedPhoto
            .drive(onNext: { [weak self] photoViewModel in
                self?.showDetail(for: photoViewModel)
            })
            .disposed(by: viewController.disposeBag)
    }

    private func showDetail(for viewModel: PhotoViewModel) {
        let viewController = PhotoDetailViewController.instance()
        viewController.viewModel = viewModel
        navigationController.showDetailViewController(viewController, sender: nil)
    }

}
