//
//  UserManager.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/1/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxCocoa

class UserManager {

    enum AuthenticationState {
        case signedIn
        case signedOut
    }

    var authenticationState: AuthenticationState = .signedOut
    var currentUser: User? = nil

}

// MARK: - LoginService

protocol LoginService {
    func login(username: String, password: String) -> Driver<Bool>
}

extension UserManager: LoginService {

    func login(username: String, password: String) -> Driver<Bool> {
        let loginResult = arc4random() % 5 == 0 ? false : true
        return Driver.just(loginResult)
            .delay(1.0)
            .do(onNext: { [weak self] _ in
                self?.authenticationState = .signedIn
            })
    }

}

// MARK: - LogoutService

protocol LogoutService {
    func logout() -> Driver<Bool>
}

extension UserManager: LogoutService {

    func logout() -> Driver<Bool> {
        return Driver.just(true)
            .delay(0.5)
            .do(onNext: { [weak self] _ in
                self?.authenticationState = .signedOut
            })
    }

}

// MARK: - SignupService

protocol SignupService {
    func signup(firstName: String, lastName: String, username: String, password: String) -> Driver<Bool>
}

extension UserManager: SignupService {

    func signup(firstName: String, lastName: String, username: String, password: String) -> Driver<Bool> {
        let signupResult = arc4random() % 5 == 0 ? false : true
        return Driver.just(signupResult)
            .delay(1.0)
            .do(onNext: { [weak self] _ in
                self?.authenticationState = .signedIn
            })
    }

}
