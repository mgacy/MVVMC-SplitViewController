//
//  NavigationController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

// MARK: - Protocols

protocol DetailViewControllerType where Self: UIViewController {}

// MARK: - Supporting

enum DetailView<T: UIViewController> {
    case visible(T)
    case empty
}

// MARK: - Class

class NavigationController: UINavigationController {

    var detailView: DetailView<UIViewController> = .empty

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        if case .visible(let detailViewController) = detailView {
            if topViewController === detailViewController {
                detailView = .empty
            } else {
                // Set detail view controller to empty to prevent confusion
                if
                    let splitViewController = splitViewController,
                    splitViewController.viewControllers.count > 1,
                    let detailNavigationController = splitViewController.viewControllers.last as? UINavigationController
                {
                    detailNavigationController.setViewControllers([makeEmptyViewController()], animated: false)
                    detailView = .empty
                }
            }
        }
        return super.popViewController(animated: animated)
    }

    // MARK: -

    /// Add detail view controller to `viewControllers` if it is visible.
    func collapseDetail() {
        switch detailView {
        case .visible(let detailViewController):
            viewControllers += [detailViewController]
        case .empty:
            return
        }
    }

    /// Remove detail view controller from `viewControllers` if it is visible.
    func separateDetail() {
        switch detailView {
        case .visible:
            viewControllers = Array(viewControllers.dropLast())
        case .empty:
            return
        }
    }

    // MARK: -

    func makeEmptyViewController() -> UIViewController {
        return EmptyDetailViewController()
    }

}
