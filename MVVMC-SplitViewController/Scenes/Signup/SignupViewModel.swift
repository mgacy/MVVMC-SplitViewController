//
//  SignupViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/1/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift

final class SignupViewModel: ViewModelType {

    let isValid: Driver<Bool>
    let signingUp: Driver<Bool>
    let signedUp: Driver<Bool>
    let cancelled: Driver<Void>

    // MARK: - Lifecycle

    init(dependency: Dependency, bindings: Bindings) {
        let userInputs = Driver.combineLatest(
            bindings.firstName, bindings.lastName, bindings.login, bindings.password
        ) { (firstName, lastName, username, password) -> (String, String, String, String) in
            return (firstName, lastName, username, password)
        }

        isValid = userInputs
            .map { firstName, lastName, username, password in
                return firstName.count > 0 && lastName.count > 0  && username.count > 0 && password.count > 0
            }

        let signingUp = ActivityIndicator()
        self.signingUp = signingUp.asDriver()

        signedUp = Driver.merge(bindings.signupTaps, bindings.doneTaps)
            .withLatestFrom(userInputs)
            .flatMap { (arg) -> Driver<Bool> in
                let (firstName, lastName, username, password) = arg
                return dependency.userManager.signup(firstName: firstName, lastName: lastName, username: username,
                                                     password: password)
                    .trackActivity(signingUp)
                    .asDriver(onErrorJustReturn: false)
            }
            //.share(replay: 1)

        cancelled = bindings.cancelTaps
    }

    // MARK: - ViewModelType

    typealias Dependency = HasClient & HasUserManager

    struct Bindings {
        let firstName: Driver<String>
        let lastName: Driver<String>
        let login: Driver<String>
        let password: Driver<String>
        let cancelTaps: Driver<Void>
        let signupTaps: Driver<Void>
        let doneTaps: Driver<Void>
    }

}
