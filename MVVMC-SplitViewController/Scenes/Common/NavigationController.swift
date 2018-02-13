//
//  NavigationController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    let detailPopCompletion: (UIViewController & EmptyDetailViewControllerType) -> Void
    var detailView: DetailView = .empty

    // MARK: - Lifecycle

    init(withPopDetailCompletion completion: @escaping (UIViewController & EmptyDetailViewControllerType) -> Void) {
        self.detailPopCompletion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
            // Set detail view controller to `EmptyDetailViewControllerType` to prevent confusion
            detailPopCompletion(makeEmptyViewController())
        case .empty:
            break
        }
        return super.popViewController(animated: animated)
    }

}

extension NavigationController: PrimaryContainerType {

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

    func makeEmptyViewController() -> UIViewController & EmptyDetailViewControllerType {
        return EmptyDetailViewController()
    }

}
