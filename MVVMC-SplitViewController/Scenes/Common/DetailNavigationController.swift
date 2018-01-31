//
//  DetailNavigationController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/29/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class DetailNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
    }

}

extension DetailNavigationController: SecondaryContainerType {

    func updateDetailView(with primaryContainer: PrimaryContainerType, in splitViewController: UISplitViewController) {
        switch primaryContainer.detailView {
        case .visible(let detailViewController):
            detailViewController.navigationItem.leftItemsSupplementBackButton = true
            detailViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
            viewControllers = [detailViewController]
        case .empty:
            viewControllers = [primaryContainer.makeEmptyViewController()]
        }
    }

}
