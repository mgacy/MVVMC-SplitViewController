//
//  UserManager.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/1/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Foundation

class UserManager {

    enum AuthenticationState {
        case signedIn
        case signedOut
    }

    var authenticationState: AuthenticationState = .signedOut
    var currentUser: User? = nil

}
