//
//  User.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/26/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}
