//
//  ProfileCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/12/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileCoordinator: BaseCoordinator<Void> {
    typealias Dependencies = HasClient & HasUserManager

    private let navigationController: UINavigationController
    private let dependencies: Dependencies

    init(navigationController: UINavigationController, dependencies: Dependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    override func start() -> Observable<CoordinationResult> {
        let viewController = ProfileViewController.instance()
        navigationController.viewControllers = [viewController]

        let avm: Attachable<ProfileViewModel> = .detached(dependencies)
        let viewModel = viewController.attach(wrapper: avm)

        viewModel.settingsTap
            .asObservable()
            .flatMap { [weak self] _ -> Observable<SettingsCoordinationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.showSettings(on: viewController)
            }
            .subscribe()
            .disposed(by: disposeBag)

        /*
        let signup = viewModel.signupTaps
            .asObservable()
            .flatMap { [weak self] _ -> Observable<SignupCoordinationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.showSignup(on: viewController)
            }
            .filter { $0 != SignupCoordinationResult.cancel }
            .map { _ in return }
        */

        return Observable.never()
    }

    private func showSettings(on rootViewController: UIViewController) -> Observable<SettingsCoordinationResult> {
        let settingsCoordinator = SettingsCoordinator(rootViewController: rootViewController, dependencies: dependencies)
        return coordinate(to: settingsCoordinator)
    }

}
