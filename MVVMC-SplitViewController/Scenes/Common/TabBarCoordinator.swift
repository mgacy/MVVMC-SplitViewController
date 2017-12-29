//
//  TabBarCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxSwift

class TabBarCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    private let client: APIClient

    enum SectionTab {
        case posts
        case todos

        var title: String {
            switch self {
            case .posts: return "Posts"
            case .todos: return "Todos"
            }
        }

        var image: UIImage {
            switch self {
            case .posts: return #imageLiteral(resourceName: "PostsTabIcon")
            case .todos: return #imageLiteral(resourceName: "TodosTabIcon")
            }
        }

        var tag: Int {
            switch self {
            case .posts: return 0
            case .todos: return 1
            }
        }
    }

    // MARK: - Lifecycle

    init(window: UIWindow, client: APIClient) {
        self.window = window
        self.client = client
    }

    override func start() -> Observable<Void> {
        let tabBarController = UITabBarController()
        let tabs: [SectionTab] = [.posts, .todos]
        let coordinationResults = Observable.from(configure(tabBarController: tabBarController, withTabs: tabs)).merge()

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        return coordinationResults
    }

    private func configure(tabBarController: UITabBarController, withTabs tabs: [SectionTab]) -> [Observable<Void>] {
        let navControllers = tabs
            .map { tab -> UINavigationController in
                let navController = UINavigationController()
                navController.tabBarItem = UITabBarItem(title: tab.title, image: tab.image, tag: tab.tag)
                if #available(iOS 11.0, *) {
                    navController.navigationBar.prefersLargeTitles = true
                }
                return navController
        }

        tabBarController.viewControllers = navControllers
        tabBarController.view.backgroundColor = UIColor.white  // Fix dark shadow in nav bar on segue

        return zip(tabs, navControllers)
            .map { (tab, navCtrl) in
                switch tab {
                case .posts:
                    let coordinator = PostsCoordinator(navigationController: navCtrl, client: client)
                    return coordinate(to: coordinator)
                case .todos:
                    let coordinator = TodosCoordinator(navigationController: navCtrl, client: client)
                    return coordinate(to: coordinator)
                }
        }
    }

}
