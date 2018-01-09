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
        switch dependencies.userManager.authenticationState {
        case .signedIn:
            return showSplitView()
        case .signedOut:
            return showLogin()
                .flatMap { [weak self] result -> Observable<Void> in
                    guard let strongSelf = self else { return .empty() }
                    return strongSelf.showSplitView()
                }
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
