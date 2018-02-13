//
//  NavigationController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    var detailView: DetailView = .empty

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        switch detailView {
        case .collapsed:
            detailView = .empty
        case .separated:
            detailView = .empty
            // Set detail view controller to empty to prevent confusion
            if
                let splitViewController = splitViewController,
                splitViewController.viewControllers.count > 1,
                let detailNavigationController = splitViewController.viewControllers.last as? UINavigationController
            {
                detailNavigationController.setViewControllers([makeEmptyViewController()], animated: true)
            }
        case .empty:
            break
        }
        return super.popViewController(animated: animated)
    }

}

extension NavigationController: PrimaryContainerType {

    /// Add detail view controller to `viewControllers` if it is visible.
    func collapseDetail() {
        switch detailView {
        case .separated(let detailViewController):
            viewControllers += [detailViewController]
            detailView = .collapsed(detailViewController)
        default:
            return
        }
    }

    /// Remove detail view controller from `viewControllers` if it is visible.
    func separateDetail() {
        switch detailView {
        case .collapsed(let detailViewController):
            viewControllers.removeLast()
            detailView = .separated(detailViewController)
        default:
            return
        }
    }

    func makeEmptyViewController() -> UIViewController & EmptyDetailViewControllerType {
        return EmptyDetailViewController()
    }

}
