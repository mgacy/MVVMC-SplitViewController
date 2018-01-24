//
//  ProfileViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/12/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt

final class ProfileViewModel: ViewModelType {

    let initials: Driver<String>
    let name: Driver<String>
    let username: Driver<String>
    let settingsTap: Driver<Void>

    // MARK: - Lifecycle

    init(dependency: Dependency, bindings: Bindings) {
        let currentUser = dependency.userManager.currentUser
            .unwrap()

        name = currentUser
            .map { $0.name }
            .asDriver(onErrorJustReturn: "Error")

        initials = name
            // https://stackoverflow.com/questions/35285978/get-the-initials-from-a-name-and-limit-it-to-2-initials
            .map { $0.components(separatedBy: " ").reduce("") { ($0 == "" ? "" : "\($0.first ?? "X")") + "\($1.first ?? "X")" } }
            .asDriver(onErrorJustReturn: "Error")

        username = currentUser
            .map { $0.username }
            .asDriver(onErrorJustReturn: "Error")

        settingsTap = bindings.settingsTaps
    }

    // MARK: - ViewModelType

    typealias Dependency = HasClient & HasUserManager

    struct Bindings {
        let settingsTaps: Driver<Void>
    }

}
