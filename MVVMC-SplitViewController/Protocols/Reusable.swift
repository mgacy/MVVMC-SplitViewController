//
//  Reusable.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//
//  Based on code from:
//  https://cocoacasts.com/dequeueing-reusable-views-with-generics-and-protocols
//  https://github.com/sergdort/CleanArchitectureRxSwift
//

import UIKit

protocol Reusable {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionReusableView: Reusable {}

extension UIViewController: Reusable {
    class func instance() -> Self {
        let storyboard = UIStoryboard(name: reuseID, bundle: nil)
        return storyboard.instantiateViewController()
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseID, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable table view cell: \(T.self)")
        }
        return cell
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.reuseID) as? T else {
            fatalError("Wrong view controller: \(T.self)")
        }
        return viewController
    }
}
