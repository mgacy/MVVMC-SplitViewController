//
//  Address.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/26/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import Foundation

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}
