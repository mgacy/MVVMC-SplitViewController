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

        viewModel.showLogin
            .asObservable()
            .flatMap { [weak self] _ -> Observable<Void> in
                guard let strongSelf = self else { return Observable.just(()) }
                return strongSelf.showLogin(on: viewController)
            }
            .subscribe()
            .disposed(by: disposeBag)
        if let navVC = rootViewController.parent as? UINavigationController, let tabVC = navVC.parent,
            let splitVC = tabVC.parent, splitVC.traitCollection.horizontalSizeClass == .regular {
            navigationController.modalPresentationStyle = .formSheet
        }

        rootViewController.present(navigationController, animated: true)

        return viewController.doneButtonItem.rx.tap
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true) })
    }

    private func showLogin(on rootViewController: UIViewController) -> Observable<Void> {
        let loginCoordinator = ModalLoginCoordinator(rootViewController: rootViewController, dependencies: dependencies)
        return coordinate(to: loginCoordinator)
    }

}
