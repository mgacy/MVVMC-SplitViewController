//
//  SettingsCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/4/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxSwift

class SettingsCoordinator: BaseCoordinator<Void> {
    typealias Dependencies = HasClient & HasUserManager

    private let navigationController: UINavigationController
    private let dependencies: Dependencies

    init(navigationController: UINavigationController, dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    override func start() -> Observable<CoordinationResult> {
        let viewController = SettingsViewController.instance()
        navigationController.viewControllers = [viewController]

        let avm: Attachable<SettingsViewModel> = .detached(dependencies)
        let viewModel = viewController.attach(wrapper: avm)

        viewModel.showLogin
            .asObservable()
            .flatMap { [weak self] _ -> Observable<Void> in
                guard let strongSelf = self else { return Observable.just(()) }
                return strongSelf.showLogin(on: viewController)
            }
            .subscribe()
            .disposed(by: disposeBag)

        return Observable.never()
    }

    private func showLogin(on rootViewController: UIViewController) -> Observable<Void> {
        let loginCoordinator = ModalLoginCoordinator(rootViewController: rootViewController, dependencies: dependencies)
        return coordinate(to: loginCoordinator)
    }

}
