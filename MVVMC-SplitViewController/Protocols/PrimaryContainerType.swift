//
//  PrimaryContainerType.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/28/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

/// Represents empty detail view controller.
protocol EmptyDetailViewControllerType: class {}

/// Represents state of `PrimaryContainerType` in split view controller.
enum DetailView {
    case collapsed(UIViewController)
    case separated(UIViewController)
    case empty
}

protocol PrimaryContainerType: class {
    var detailView: DetailView { get set }
    func collapseDetail()
    func separateDetail()
    func makeEmptyViewController() -> UIViewController & EmptyDetailViewControllerType
}
