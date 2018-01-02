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

    private let window: UIWindow
    private let client: APIClient

    init(window: UIWindow, client: APIClient) {
        self.window = window
        self.client = client
    }

    override func start() -> Observable<CoordinationResult> {
        var viewController = LoginViewController.instance()
        var avm: Attachable<LoginViewModel> = .detached(LoginViewModel.Dependency(client: client))
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
        let signupCoordinator = SignupCoordinator(rootViewController: rootViewController, client: self.client)
        return coordinate(to: signupCoordinator)
    }

}
