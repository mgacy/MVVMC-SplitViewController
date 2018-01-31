//
//  SettingsCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/4/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxSwift

/// Type defining possible coordination results of the `SettingsCoordinator`.
///
/// - none:   No changes to user authentication status.
/// - logout: User logged out.
/// - login:  User logged out and back in again (possibly as a different user).
enum SettingsCoordinationResult {
    case none
    case logout
    case login
}

class SettingsCoordinator: BaseCoordinator<SettingsCoordinationResult> {
    typealias Dependencies = HasClient & HasUserManager

    private let rootViewController: UIViewController
    private let dependencies: Dependencies

    init(rootViewController: UIViewController, dependencies: Dependencies) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }

    override func start() -> Observable<CoordinationResult> {
        let viewController = SettingsViewController.instance()
        let navigationController = UINavigationController(rootViewController: viewController)

        let avm: Attachable<SettingsViewModel> = .detached(dependencies)
        let viewModel = viewController.attach(wrapper: avm)

        let login = viewModel.showLogin
            .asObservable()
            .flatMap { [weak self] _ -> Observable<ModalLoginCoordinationResult> in
                guard let strongSelf = self else { return .empty() }
                return strongSelf.showLogin(on: viewController)
            }
            .filter { $0 == .login }
            .map { _ in return SettingsCoordinationResult.login }

        let logout = viewModel.didLogout
            .asObservable()
            .map { _ in return SettingsCoordinationResult.logout }

        let authenticationChanges = Observable.of(logout, login)
            .merge()
            .startWith(SettingsCoordinationResult.none)

        if let navVC = rootViewController.parent as? UINavigationController, let tabVC = navVC.parent,
            let splitVC = tabVC.parent, splitVC.traitCollection.horizontalSizeClass == .regular {
            navigationController.modalPresentationStyle = .formSheet
        }

        rootViewController.present(navigationController, animated: true)

        return viewController.doneButtonItem.rx.tap
            .take(1)
            .withLatestFrom(authenticationChanges)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }

    private func showLogin(on rootViewController: UIViewController) -> Observable<ModalLoginCoordinationResult> {
        let loginCoordinator = ModalLoginCoordinator(rootViewController: rootViewController, dependencies: dependencies)
        return coordinate(to: loginCoordinator)
    }

}
