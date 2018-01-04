//
//  AttachableType.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import UIKit
import RxSwift

protocol AttachableType {
    associatedtype ViewModel: AttachableViewModelType

    var bindings: ViewModel.Bindings { get }
    var viewModel: ViewModel! { get set }

    func bindViewModel()
}

extension AttachableType where Self: UIViewController {

    @discardableResult
    mutating func bind(toViewModel model: inout Attachable<ViewModel>) -> ViewModel {
        loadViewIfNeeded()
        viewModel = model.bind(bindings)
        bindViewModel()
        return viewModel
    }

}
