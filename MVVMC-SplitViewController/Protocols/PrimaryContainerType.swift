//
//  PrimaryContainerType.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/28/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

typealias PrimaryContainerType = SplitTabRootViewControllerType & PlaceholderFactory

/// Represents state of detail view controller in split view controller.
enum DetailView {
    case collapsed(UIViewController)
    case separated(UIViewController)
    case placeholder
}

protocol SplitTabRootViewControllerType: AnyObject {
    /// Called to update secondary view controller with `PlaceholderViewControllerType` when popping view controller.
    var detailPopCompletion: (UIViewController & PlaceholderViewControllerType) -> Void { get }

    /// Represents state of detail view controller in split view controller.
    var detailView: DetailView { get set }

    /// Add detail view controller to `viewControllers` if it is visible and update `detailView`.
    func collapseDetail()

    /// Remove detail view controller from `viewControllers` if it is visible and update `detailView`.
    func separateDetail()
}

extension SplitTabRootViewControllerType where Self: UINavigationController {

    func collapseDetail() {
        switch detailView {
        case .separated(let detailViewController):
            viewControllers += [detailViewController]
            detailView = .collapsed(detailViewController)
        default:
            return
        }
    }

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

/// Represents empty detail view controller.
protocol PlaceholderViewControllerType: AnyObject {}

protocol PlaceholderFactory {
    /// Factory method to produce tab-specific placeholder for secondary view controller.
    func makePlaceholderViewController() -> UIViewController & PlaceholderViewControllerType
}
