//
//  TabBarController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func collapseSecondaryViewController(_ secondaryViewController: UIViewController, for splitViewController: UISplitViewController) {
        collapseTabs()
    }

    override func separateSecondaryViewController(for splitViewController: UISplitViewController) -> UIViewController? {
        return viewControllers?
            .flatMap { vc in
                guard let navController = vc as? PrimaryContainerType else { return nil }
                navController.separateDetail()
                return vc
            }
            .filter { $0 == self.selectedViewController }
            .first
    }

    // MARK: -

    /// Call `PrimaryContainerType.collapseDetail()` on children to add visible detail view controllers.
    func collapseTabs() {
        guard let vcs = viewControllers else { return }
        vcs.forEach { viewController in
            guard let navController = viewController as? PrimaryContainerType else {
                fatalError("\(#function) FAILED : wrong view controller type")
            }
            navController.collapseDetail()
        }
    }

    /// Call `PrimaryContainerType.separateDetail()` on children to remove visible detail view controllers.
    func separateTabs() {
        guard let vcs = viewControllers else { return }
        vcs.forEach { viewController in
            guard let navController = viewController as? PrimaryContainerType else {
                fatalError("\(#function) FAILED : wrong view controller type")
            }
            navController.separateDetail()
        }
    }

}
