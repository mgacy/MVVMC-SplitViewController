//
//  SplitViewDelegate.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxSwift

class SplitViewDelegate: NSObject {

    private let splitViewController: UISplitViewController
    private let tabBarController: TabBarController
    private let detailNavigationController: UINavigationController

    init(splitViewController: UISplitViewController, tabBarController: TabBarController) {
        self.splitViewController = splitViewController
        self.tabBarController = tabBarController
        self.detailNavigationController = UINavigationController()
        super.init()

        // Tab
        tabBarController.delegate = self

        // Detail
        detailNavigationController.viewControllers = [EmptyDetailViewController()]
        detailNavigationController.navigationBar.isTranslucent = false

        // Split
        splitViewController.delegate = self
        splitViewController.viewControllers = [tabBarController, detailNavigationController]
        splitViewController.preferredDisplayMode = .allVisible
    }

}

// MARK: - UITabBarControllerDelegate
extension SplitViewDelegate: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Prevent selection of the same tab twice (which would reset the section's navigation controller)
        if tabBarController.selectedViewController === viewController {
            return false
        } else {
            return true
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        // If svc is collapsed, detail will be on section nav controller if it is visible
        if splitViewController.isCollapsed { return }

        // Otherwise, we want to change the secondary view controller to this tab's detail view
        guard let navigationController = viewController as? PrimaryContainerType else {
                fatalError("\(#function) FAILED : wrong view controller type")
        }
        switch navigationController.detailView {
        case .visible(let detailViewController):
            detailViewController.navigationItem.leftItemsSupplementBackButton = true
            detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
            detailNavigationController.viewControllers = [detailViewController]
        case .empty:
            detailNavigationController.viewControllers = [navigationController.makeEmptyViewController()]
        }
    }

}

// MARK: - UISplitViewControllerDelegate
extension SplitViewDelegate: UISplitViewControllerDelegate {

    // MARK: Overriding the Interface Orientations

    // MARK: Collapsing the Interface
    /*
    // This method is called when a split view controller is collapsing its children for a transition to a compact-width
    // size class. Override this method to perform custom adjustments to the view controller hierarchy of the target
    // controller. When you return from this method, you're expected to have modified the `primaryViewController` so as
    // to be suitable for display in a compact-width split view controller, potentially using `secondaryViewController`
    // to do so.
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return false
        /*
        guard
            let tabBarController = splitViewController.viewControllers.first as? TabBarController,
            let navigationController = tabBarController.selectedViewController as? NavigationController else {
                fatalError("\(#function) FAILED : unable to get selectedViewController")
        }
        tabBarController.collapseTabs()
        */
        return true // Prevent UIKit from performing default collapse behavior
    }
    */
    // MARK: Expanding the Interface

    // This method is called when a split view controller is separating its child into two children for a transition
    // from a compact-width size class to a regular-width size class. Override this method to perform custom separation
    // behavior. The controller returned from this method will be set as the secondary view controller of the split
    // view controller. When you return from this method, `primaryViewController` should have been configured for
    // display in a regular-width split view controller. If you return `nil`, then `UISplitViewController` will perform
    // its default behavior.
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        guard
            let tabBarController = primaryViewController as? TabBarController,
            let selectedNavController = tabBarController.selectedViewController as? PrimaryContainerType else {
                fatalError("\(#function) FAILED : unable to get selectedViewController")
        }

        tabBarController.separateTabs()

        switch selectedNavController.detailView {
        case .visible(let detailViewController):
            detailViewController.navigationItem.leftItemsSupplementBackButton = true
            detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
            detailNavigationController.viewControllers = [detailViewController]
        case .empty:
            detailNavigationController.viewControllers = [selectedNavController.makeEmptyViewController()]
        }
        return detailNavigationController
    }

    // MARK: Overriding the Presentation Behavior

    // Customize the behavior of `showDetailViewController:` on a split view controller.
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard
            let tabBarController = splitViewController.viewControllers.first as? UITabBarController,
            let navigationController = tabBarController.selectedViewController as? NavigationController else {
                fatalError("\(#function) FAILED : unable to get section navigation controller")
        }
        if splitViewController.isCollapsed {
            navigationController.pushViewController(vc, animated: true)
        } else {
            vc.navigationItem.leftItemsSupplementBackButton = true
            vc.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem

            switch navigationController.detailView {
            // Animate only the initial presentation of the detail vc
            case .empty:
                detailNavigationController.setViewControllers([vc], animated: true)
            case .visible:
                detailNavigationController.setViewControllers([vc], animated: false)
            }
        }
        navigationController.detailView = .visible(vc)
        return true // Prevent UIKit from performing default behavior
    }

}
