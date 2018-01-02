//
//  SignupViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/1/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift

final class SignupViewModel: AttachableViewModelType {

    struct Dependency {
        let client: APIClient
    }

    struct Bindings {
        let firstName: Driver<String>
        let lastName: Driver<String>
        let login: Driver<String>
        let password: Driver<String>
        let cancelTaps: Driver<Void>
        let signupTaps: Driver<Void>
        let doneTaps: Driver<Void>
    }

    // Properties
    let isValid: Driver<Bool>
    let signingUp: Driver<Bool>
    let signedUp: Driver<Bool>
    let cancelled: Driver<Void>

    // MARK: - Lifecycle
    init(dependency: Dependency, bindings: Bindings) {
        let userInputs = Driver.combineLatest(
            bindings.firstName, bindings.lastName, bindings.login, bindings.password
        ) { (firstName, lastName, login, password) -> (String, String, String, String) in
            return (firstName, lastName, login, password)
        }

        isValid = userInputs
            .map { firstName, lastName, login, password in
                return firstName.count > 0 && lastName.count > 0  && login.count > 0 && password.count > 0
            }

        let signingUp = ActivityIndicator()
        self.signingUp = signingUp.asDriver()

        signedUp = Driver.merge(bindings.signupTaps, bindings.doneTaps)
            .withLatestFrom(userInputs)
            .flatMap { (arg) -> Driver<Bool> in
                //let (firstName, lastName, login, password) = arg
                let signupResult = arc4random() % 5 == 0 ? false : true
                return Driver.just(signupResult)
                    .delay(1.0)
                    .trackActivity(signingUp)
                    .asDriver(onErrorJustReturn: false)
            }
            //.share(replay: 1)

        cancelled = bindings.cancelTaps
    }

}
