//
//  Todo.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/26/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import Foundation

struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
