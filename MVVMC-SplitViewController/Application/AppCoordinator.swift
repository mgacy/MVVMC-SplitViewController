//
//  AppCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    private let client: APIClient

    init(window: UIWindow) {
        self.window = window
        self.client = APIClient()
    }

    override func start() -> Observable<Void> {
        let tabBarCoordinator = TabBarCoordinator(window: window, client: client)
        return coordinate(to: tabBarCoordinator)
    }

}
