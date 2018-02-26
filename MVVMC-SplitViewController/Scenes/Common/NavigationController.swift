//
//  NavigationController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController, PrimaryContainerType {

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

    func makeEmptyViewController() -> UIViewController & EmptyDetailViewControllerType {
        return EmptyDetailViewController()
    }

}
