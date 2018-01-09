//
//  SettingsViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/4/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift

struct SettingsViewModel: ViewModelType {

    let accountCellText: Driver<String>
    let didLogout: Driver<Bool>
    let showLogin: Driver<Void>

    // MARK: - Lifecycle

    init(dependency: Dependency, bindings: Bindings) {

        accountCellText = dependency.userManager.username
            .asDriver()
            .map { username in
                return username != nil ? "Logout \(username!)" : "Login"
            }

        let accountCellTaps = bindings.selection
            //.debug("accountCellTaps")
            .filter { $0.section == 0 }

        didLogout = accountCellTaps
            .filter { _ in dependency.userManager.authenticationState == .signedIn }
            .flatMap { _ in
                return dependency.userManager.logout()
            }

        showLogin = accountCellTaps
            .filter { _ in dependency.userManager.authenticationState == .signedOut }
            .map { _ in return }
    }

    typealias Dependency = HasUserManager

    struct Bindings {
        let selection: Driver<IndexPath>
    }

}
