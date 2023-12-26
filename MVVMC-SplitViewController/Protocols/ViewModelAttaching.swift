//
//  ViewModelAttaching.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import UIKit
import RxSwift

protocol ViewModelAttaching: AnyObject {
    associatedtype ViewModel: ViewModelType

    var bindings: ViewModel.Bindings { get }
    var viewModel: Attachable<ViewModel>! { get set }

    func attach(wrapper: Attachable<ViewModel>) -> ViewModel
    func bind(viewModel: ViewModel) -> ViewModel
}

extension ViewModelAttaching where Self: UIViewController {

    @discardableResult
    func attach(wrapper: Attachable<ViewModel>) -> ViewModel {
        viewModel = wrapper
        loadViewIfNeeded()
        let vm = viewModel.bind(bindings)
        return bind(viewModel: vm)
    }

}
