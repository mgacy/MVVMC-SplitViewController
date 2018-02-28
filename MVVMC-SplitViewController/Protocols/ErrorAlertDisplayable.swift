//
//  ErrorAlertDisplayable.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 2/27/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa

protocol ErrorAlertDisplayable {
    var errorAlert: Binder<String> { get }
}

extension ErrorAlertDisplayable where Self: UIViewController {
    var errorAlert: Binder<String> {
        return Binder(self) { viewController, message in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alert.addAction(action)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
