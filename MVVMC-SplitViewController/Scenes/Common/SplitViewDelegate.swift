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
    private let detailNavigationController: DetailNavigationController

    init(splitViewController: UISplitViewController, tabBarController: TabBarController) {
        self.splitViewController = splitViewController
        self.tabBarController = tabBarController
        self.detailNavigationController = DetailNavigationController()
        super.init()

        // Tab
        tabBarController.delegate = self

        // Detail
        guard let initialPrimaryView = tabBarController.selectedViewController as? PrimaryContainerType else {
                fatalError("\(#function) FAILED : wrong view controller type")
        }
        detailNavigationController.updateDetailView(with: initialPrimaryView, in: splitViewController)

        // Split
        splitViewController.delegate = self
        splitViewController.viewControllers = [tabBarController, detailNavigationController]
        splitViewController.preferredDisplayMode = .allVisible
    }

}

// MARK: - UITabBarControllerDelegate
extension SplitViewDelegate: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // Prevent selection of the same tab twice (which would reset its navigation controller)
        if tabBarController.selectedViewController === viewController {
            return false
        } else {
            return true
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard
            let splitViewController = tabBarController.splitViewController,
            let selectedNavController = viewController as? PrimaryContainerType else {
                fatalError("\(#function) FAILED : wrong view controller type")
        }
        // If split view controller is collapsed, detail view will already be on `selectedNavController.viewControllers`;
        // otherwise, we need to change the secondary view controller to the selected tab's detail view.
        if !splitViewController.isCollapsed {
            detailNavigationController.updateDetailView(with: selectedNavController, in: splitViewController)
        }
    }

}

// MARK: - UISplitViewControllerDelegate
extension SplitViewDelegate: UISplitViewControllerDelegate {

    // MARK: Collapsing the Interface

    // This method is called when a split view controller is collapsing its children for a transition to a compact-width
    // size class.
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard
            let tabBarController = splitViewController.viewControllers.first as? UITabBarController,
            let navigationControllers = tabBarController.viewControllers as? [PrimaryContainerType] else {
                fatalError("\(#function) FAILED : wrong view controller type")
        }

        navigationControllers.forEach { $0.collapseDetail() }
        return true // Prevent UIKit from performing default collapse behavior
    }

    // MARK: Expanding the Interface

    // This method is called when a split view controller is separating its child into two children for a transition
    // from a compact-width size class to a regular-width size class.
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        guard
            let tabBarController = primaryViewController as? UITabBarController,
            let navigationControllers = tabBarController.viewControllers as? [PrimaryContainerType],
            let selectedNavController = tabBarController.selectedViewController as? PrimaryContainerType else {
                fatalError("\(#function) FAILED : unable to get selectedViewController")
        }

        navigationControllers.forEach { $0.separateDetail() }

        detailNavigationController.updateDetailView(with: selectedNavController, in: splitViewController)
        return detailNavigationController
    }

    // MARK: Overriding the Presentation Behavior

    // Customize the behavior of `showDetailViewController:` on a split view controller.
    func splitViewController(_ splitViewController: UISplitViewController, showDetail vc: UIViewController, sender: Any?) -> Bool {
        guard
            let tabBarController = splitViewController.viewControllers.first as? UITabBarController,
            let selectedNavController = tabBarController.selectedViewController as? NavigationController else {
                fatalError("\(#function) FAILED : unable to get section navigation controller")
        }

        vc.navigationItem.leftItemsSupplementBackButton = true
        vc.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem

        if splitViewController.isCollapsed {
            selectedNavController.pushViewController(vc, animated: true)
        } else {
            switch selectedNavController.detailView {
            // Animate only the initial presentation of the detail vc
            case .empty:
                detailNavigationController.setViewControllers([vc], animated: true)
            case .visible:
                detailNavigationController.setViewControllers([vc], animated: false)
            }
        }
        selectedNavController.detailView = .visible(vc)
        return true // Prevent UIKit from performing default behavior
    }

}
