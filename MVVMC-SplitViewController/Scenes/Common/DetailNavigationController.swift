//
//  DetailNavigationController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/29/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class DetailNavigationController: UINavigationController {

    init() {
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
    }

}

// MARK: - UINavigationControllerDelegate
extension DetailNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .push, toVC is EmptyDetailViewController else {
            return nil
        }

        return DetailNavigationControllerAnimator(operation: operation)
    }

}
