//
//  LoginCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/1/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxSwift

class LoginCoordinator: BaseCoordinator<Void> {
    typealias Dependencies = HasClient & HasUserManager

    private let window: UIWindow
    private let dependencies: Dependencies

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
    }

    override func start() -> Observable<CoordinationResult> {
        let viewController = LoginViewController.instance()
        var avm: Attachable<LoginViewModel> = .detached(dependencies)
        let viewModel = viewController.bind(toViewModel: &avm)

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
