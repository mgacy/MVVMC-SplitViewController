//
//  Photo.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/26/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: URL
    let thumbnailUrl: URL
}
