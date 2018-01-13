//
//  ProfileViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/12/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift

final class ProfileViewModel: ViewModelType {

    let name: Driver<String>
    let username: Driver<String>
    let settingsTap: Driver<Void>

    // MARK: - Lifecycle

    init(dependency: Dependency, bindings: Bindings) {
        //name = dependency.userManager.username
        name = Driver.just("A")
        username = Driver.just("A")
        settingsTap = bindings.settingsTaps
    }

    // MARK: - ViewModelType

    typealias Dependency = HasClient & HasUserManager

    struct Bindings {
        let settingsTaps: Driver<Void>
    }

}
