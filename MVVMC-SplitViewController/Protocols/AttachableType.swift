//
//  AttachableType.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import UIKit
import RxSwift

protocol AttachableType: class {
    associatedtype ViewModel: AttachableViewModelType

    var bindings: ViewModel.Bindings { get }
    var viewModel: ViewModel! { get set }

    func bindViewModel()
}

extension AttachableType where Self: UIViewController {

    @discardableResult
    func bind(toViewModel wrapper: inout Attachable<ViewModel>) -> ViewModel {
        loadViewIfNeeded()
        viewModel = wrapper.bind(bindings)
        bindViewModel()
        return viewModel
    }

}
