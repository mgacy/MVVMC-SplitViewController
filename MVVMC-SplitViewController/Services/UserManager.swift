//
//  UserManager.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/1/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserManager {

    enum AuthenticationState {
        case signedIn
        case signedOut
    }

    var authenticationState: AuthenticationState
    let currentUser = BehaviorSubject<User?>(value: nil)
    private let client = APIClient()
    private let storageManager: UserStorageManagerType

    init() {
        self.storageManager = UserStorageManager()
        if let user = storageManager.read() {
            self.authenticationState = .signedIn
            self.currentUser.onNext(user)
        } else {
            self.authenticationState = .signedOut
        }
    }

}

enum AuthenticationError: Error {
    case invalidCredentials
}

// MARK: - LoginService

protocol LoginService {
    func login(username: String, password: String) -> Observable<Bool>
}

extension UserManager: LoginService {

    func login(username: String, password: String) -> Observable<Bool> {
        // just a mock
        let loginResult = arc4random() % 5 == 0 ? false : true
        if loginResult == false {
            return .error(AuthenticationError.invalidCredentials)
        }

        return client.getUser(id: 1)
            .do(onNext: { [weak self] user in
                self?.authenticationState = .signedIn
                self?.currentUser.onNext(user)
                self?.storageManager.store(user: user)
            })
            .map { _ in return true }
    }

}

// MARK: - LogoutService

protocol LogoutService {
    func logout() -> Observable<Bool>
}

extension UserManager: LogoutService {

    func logout() -> Observable<Bool> {
        // just a mock
        return Observable.just(true)
            .delay(0.5, scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.authenticationState = .signedOut
                self?.storageManager.clear()
                self?.currentUser.onNext(nil)
            })
    }

}

// MARK: - SignupService

protocol SignupService {
    func signup(firstName: String, lastName: String, username: String, password: String) -> Observable<Bool>
}

extension UserManager: SignupService {

    func signup(firstName: String, lastName: String, username: String, password: String) -> Observable<Bool> {
        // just a mock
        let signupResult = arc4random() % 5 == 0 ? false : true
        if signupResult == false {
            return .error(AuthenticationError.invalidCredentials)
        }

        return client.getUser(id: 1)
            .do(onNext: { [weak self] user in
                self?.authenticationState = .signedIn
                self?.currentUser.onNext(user)
                self?.storageManager.store(user: user)
            })
            .map { _ in return true }
    }

}

// MARK: - Persistence

protocol UserStorageManagerType {
    func store(user: User)
    func read() -> User?
    func clear()
}

class UserStorageManager: UserStorageManagerType {
    private let encoder: JSONEncoder
    private let archiveURL: URL

    init() {
        encoder = JSONEncoder()
        archiveURL = UserStorageManager.getDocumentsURL().appendingPathComponent("user")
    }

    func store(user: User) {
        // should incorporate better error handling
        do {
            let data = try encoder.encode(user)
            guard NSKeyedArchiver.archiveRootObject(data, toFile: archiveURL.path) else {
                fatalError("Could not store data to url")
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func read() -> User? {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: archiveURL.path) as? Data {
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(User.self, from: data)
                return user
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            return nil
        }
    }

    func clear() {
        // should incorporate better error handling
        do {
            try FileManager.default.removeItem(at: archiveURL)
        } catch {
            fatalError("Could not delete data from url")
        }
    }

    // MARK: - Helper Methods

    private static func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            // should incorporate better error handling
            fatalError("Could not retrieve documents directory")
        }
    }

}
