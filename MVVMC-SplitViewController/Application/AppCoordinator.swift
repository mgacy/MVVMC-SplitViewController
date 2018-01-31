//
//  AppCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    private let dependencies: AppDependency

    init(window: UIWindow) {
        self.window = window
        self.dependencies = AppDependency()
    }

    override func start() -> Observable<Void> {
        coordinateToRoot()
        return .never()
    }

    // Recursive method that will restart a child coordinator after completion.
    // Based on:
    // https://github.com/uptechteam/Coordinator-MVVM-Rx-Example/issues/3
    private func coordinateToRoot() {
        switch dependencies.userManager.authenticationState {
        case .signedIn:
            return showSplitView()
                .subscribe(onNext: { [weak self] _ in
                    self?.window.rootViewController = nil
                    self?.coordinateToRoot()
                })
                .disposed(by: disposeBag)
        case .signedOut:
            return showLogin()
                .subscribe(onNext: { [weak self] _ in
                    self?.window.rootViewController = nil
                    self?.coordinateToRoot()
                })
                .disposed(by: disposeBag)
        }
    }

    private func showSplitView() -> Observable<Void> {
        let splitViewCoordinator = SplitViewCoordinator(window: self.window, dependencies: dependencies)
        return coordinate(to: splitViewCoordinator)
    }

    private func showLogin() -> Observable<Void> {
        let loginCoordinator = LoginCoordinator(window: window, dependencies: dependencies)
        return coordinate(to: loginCoordinator)
    }

}
