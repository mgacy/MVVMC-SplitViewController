//
//  UserManager.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/1/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxSwift
import RxCocoa

class UserManager {

    enum AuthenticationState {
        case signedIn
        case signedOut
    }

    var authenticationState: AuthenticationState
    var username: Variable<String?>
    private let storageManager: UserStorageManagerType

    init() {
        self.storageManager = UserStorageManager()
        if let username = storageManager.read() {
            self.authenticationState = .signedIn
            self.username = Variable<String?>(username)
        } else {
            self.authenticationState = .signedOut
            self.username = Variable<String?>(nil)
        }
    }

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
                self?.storageManager.store(username: username)
                self?.username.value = username
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
                self?.storageManager.clear()
                self?.username.value = nil
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
                self?.storageManager.store(username: username)
                self?.username.value = username
            })
    }

}

// MARK: - Persistence

protocol UserStorageManagerType {
    func store(username: String)
    func read() -> String?
    func clear()
}

class UserStorageManager: UserStorageManagerType {
    private let defaults: UserDefaults
    private let defaultsKey: String

    init(defaults: UserDefaults = .standard, defaultsKey: String = "username") {
        self.defaults = defaults
        self.defaultsKey = defaultsKey
    }

    func store(username: String) {
        defaults.set(username, forKey: defaultsKey)
    }

    func read() -> String? {
        return defaults.string(forKey: defaultsKey)
    }

    func clear() {
        defaults.removeObject(forKey: defaultsKey)
    }

}
