//
//  SecondaryContainerType.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/29/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

protocol SecondaryContainerType: class {
    var viewControllers: [UIViewController] { get set }
    func setViewControllers(_: [UIViewController], animated: Bool)
    func updateDetailView(with: PrimaryContainerType, in: UISplitViewController)
}
