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
    associatedtype Bindings

    var bindings: Bindings { get }
    var viewModel: ViewModel! { get set }

    func bindViewModel()
}

extension AttachableType where Self: UIViewController {

    @discardableResult
    mutating func bind<T>(toViewModel model: inout Attachable<T>) -> T where T == Self.ViewModel, T.Bindings == Self.Bindings {
        loadViewIfNeeded()
        viewModel = model.bind(bindings)
        bindViewModel()
        return viewModel
    }

}
