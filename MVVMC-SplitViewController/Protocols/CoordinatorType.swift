//
//  Coordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/23/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxSwift

protocol CoordinatorType {
    associatedtype CoordinationResult
    var identifier: UUID { get }
    func start() -> Observable<CoordinationResult>
}
