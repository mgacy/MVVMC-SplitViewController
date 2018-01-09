//
//  TabBarCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxSwift

class TabBarCoordinator: BaseCoordinator<Void> {
    typealias Dependencies = HasClient & HasUserManager

    private let window: UIWindow
    private let dependencies: Dependencies

    enum SectionTab {
        case posts
        case todos
        case settings

        var title: String {
            switch self {
            case .posts: return "Posts"
            case .todos: return "Todos"
            case .settings: return "Settings"
            }
        }

        var image: UIImage {
            switch self {
            case .posts: return #imageLiteral(resourceName: "PostsTabIcon")
            case .todos: return #imageLiteral(resourceName: "TodosTabIcon")
            case .settings: return #imageLiteral(resourceName: "Settings")
            }
        }

        var tag: Int {
            switch self {
            case .posts: return 0
            case .todos: return 1
            case .settings: return 2
            }
        }
    }

    // MARK: - Lifecycle

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
    }

    override func start() -> Observable<Void> {
        let tabBarController = UITabBarController()
        let tabs: [SectionTab] = [.posts, .todos, .settings]
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
                //navController.navigationBar.prefersLargeTitles = true
                //navController.navigationItem.largeTitleDisplayMode = .automatic
                return navController
            }

        tabBarController.viewControllers = navControllers
        tabBarController.view.backgroundColor = UIColor.white  // Fix dark shadow in nav bar on segue

        return zip(tabs, navControllers)
            .map { (tab, navCtrl) in
                switch tab {
                case .posts:
                    let coordinator = PostsCoordinator(navigationController: navCtrl, dependencies: dependencies)
                    return coordinate(to: coordinator)
                case .todos:
                    let coordinator = TodosCoordinator(navigationController: navCtrl, dependencies: dependencies)
                    return coordinate(to: coordinator)
                case .settings:
                    let coordinator = SettingsCoordinator(navigationController: navCtrl, dependencies: dependencies)
                    return coordinate(to: coordinator)
                }
            }
    }

}
