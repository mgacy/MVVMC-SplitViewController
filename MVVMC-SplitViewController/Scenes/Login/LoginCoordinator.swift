//
//  LoginCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/1/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginCoordinator: BaseCoordinator<Void> {
    typealias Dependencies = HasUserManager

    private let window: UIWindow
    private let dependencies: Dependencies

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
    }

    override func start() -> Observable<CoordinationResult> {
        let viewController = LoginViewController()
        let avm: Attachable<LoginViewModel> = .detached(dependencies)
        let viewModel = viewController.attach(wrapper: avm)

        let login = viewModel.loggedIn
            .asObservable()
            .filter { $0 }
            .map { _ in return }

        let signup = viewModel.signupTaps
            .asObservable()
            .flatMap { [weak self] _ -> Observable<SignupCoordinationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.showSignup(on: viewController)
            }
            .filter { $0 != SignupCoordinationResult.cancel }
            .map { _ in return }

        window.rootViewController = viewController
        window.makeKeyAndVisible()

        return Observable.merge(login, signup)
            .take(1)
    }

    private func showSignup(on rootViewController: UIViewController) -> Observable<SignupCoordinationResult> {
        let signupCoordinator = SignupCoordinator(rootViewController: rootViewController, dependencies: dependencies)
        return coordinate(to: signupCoordinator)
    }

}

// MARK: - Modal Presentation

enum ModalLoginCoordinationResult {
    case login
    case cancel
}

class ModalLoginCoordinator: BaseCoordinator<ModalLoginCoordinationResult> {
    typealias Dependencies = HasUserManager

    private let rootViewController: UIViewController
    private let dependencies: Dependencies

    init(rootViewController: UIViewController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }

    override func start() -> Observable<CoordinationResult> {
        let viewController = LoginViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        let avm: Attachable<LoginViewModel> = .detached(dependencies)
        let viewModel = viewController.attach(wrapper: avm)

        let login = viewModel.loggedIn
            .filter { $0 }
            .map { _ in return ModalLoginCoordinationResult.login }

        let cancel = viewModel.cancelTaps
            .map { _ in return ModalLoginCoordinationResult.cancel }

        rootViewController.present(navigationController, animated: true)

        return Driver.merge(cancel, login)
            .asObservable()
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }

    private func showSignup(on rootViewController: UIViewController) -> Observable<SignupCoordinationResult> {
        let signupCoordinator = SignupCoordinator(rootViewController: rootViewController, dependencies: dependencies)
        return coordinate(to: signupCoordinator)
    }

}
