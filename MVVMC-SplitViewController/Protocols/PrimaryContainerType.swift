//
//  PrimaryContainerType.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/28/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit


/// Represents state of `PrimaryContainerType` in split view controller.
enum DetailView {
    case collapsed(UIViewController)
    case separated(UIViewController)
    case placeholder
}

/// Represents empty detail view controller.
protocol PlaceholderViewControllerType: class {}
protocol PrimaryContainerType: class {
    var detailPopCompletion: (UIViewController & PlaceholderViewControllerType) -> Void { get }
    var detailView: DetailView { get set }

    func collapseDetail()
    func separateDetail()
    func makeEmptyViewController() -> UIViewController & PlaceholderViewControllerType
}

extension PrimaryContainerType where Self: UINavigationController {

    /// Add detail view controller to `viewControllers` if it is visible and update `detailView`.
    func collapseDetail() {
        switch detailView {
        case .separated(let detailViewController):
            viewControllers += [detailViewController]
            detailView = .collapsed(detailViewController)
        default:
            return
        }
    }

    /// Remove detail view controller from `viewControllers` if it is visible and update `detailView`.
    func separateDetail() {
        switch detailView {
        case .collapsed(let detailViewController):
            viewControllers.removeLast()
            detailView = .separated(detailViewController)
        default:
            return
        }
    }

}
