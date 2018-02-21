//
//  TabBarController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let detailNavigationController: UINavigationController

    // MARK: - Lifecycle

    init(detailNavigationController: UINavigationController) {
        self.detailNavigationController = detailNavigationController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - A

    override func collapseSecondaryViewController(_ secondaryViewController: UIViewController, for splitViewController: UISplitViewController) {
        guard let navigationControllers = viewControllers as? [PrimaryContainerType] else { return }
        navigationControllers.forEach { $0.collapseDetail() }
    }

    override func separateSecondaryViewController(for splitViewController: UISplitViewController) -> UIViewController? {
        guard
            let navigationControllers = viewControllers as? [PrimaryContainerType],
            let selectedNavController = selectedViewController as? PrimaryContainerType else {
                fatalError("Wrong view controller type: \(String(describing: viewControllers?.filter { !($0 is PrimaryContainerType) }))")
        }

        navigationControllers.forEach { $0.separateDetail() }

        if case .empty = selectedNavController.detailView {
            splitViewController.preferredDisplayMode = .allVisible
        }
        updateSecondaryWithDetail(from: selectedNavController)
        return detailNavigationController
    }

    // MARK: - B

    func updateSecondaryWithDetail(from primaryContainer: PrimaryContainerType, animated: Bool = false) {
        switch primaryContainer.detailView {
        case .collapsed(let detailViewController):
            detailNavigationController.setViewControllers([detailViewController], animated: animated)
        case .separated(let detailViewController):
            detailNavigationController.setViewControllers([detailViewController], animated: animated)
        case .empty:
            detailNavigationController.setViewControllers([primaryContainer.makeEmptyViewController()],
                                                          animated: animated)
        }
    }

    func replaceDetail(withEmpty viewController: UIViewController & EmptyDetailViewControllerType) {
        detailNavigationController.setViewControllers([viewController], animated: true)
    }

}
