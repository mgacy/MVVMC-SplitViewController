//
//  SplitViewCoordinator.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxSwift

class SplitViewCoordinator: BaseCoordinator<Void> {
    typealias Dependencies = HasClient & HasUserManager

    private let window: UIWindow
    private let dependencies: Dependencies

    private let splitViewController: UISplitViewController
    private let tabBarController: TabBarController
    // swiftlint:disable:next weak_delegate
    private var viewDelegate: SplitViewDelegate?

    enum SectionTab {
        case posts
        case albums
        case todos
        case profile

        var title: String {
            switch self {
            case .posts: return "Posts"
            case .albums: return "Albums"
            case .todos: return "Todos"
            case .profile: return "Profile"
            }
        }

        var image: UIImage {
            switch self {
            case .posts: return #imageLiteral(resourceName: "PostsTabIcon")
            case .albums: return #imageLiteral(resourceName: "AlbumsTabIcon")
            case .todos: return #imageLiteral(resourceName: "TodosTabIcon")
            case .profile: return #imageLiteral(resourceName: "ProfileTabIcon")
            }
        }

        var tag: Int {
            switch self {
            case .posts: return 0
            case .albums: return 1
            case .todos: return 2
            case .profile: return 3
            }
        }
    }

    // MARK: - Lifecycle

    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
        self.splitViewController = UISplitViewController()
        self.tabBarController = TabBarController()
    }

    override func start() -> Observable<CoordinationResult> {
        let tabBarController = TabBarController()
        let tabs: [SectionTab] = [.posts, .albums, .todos, .profile]
        let coordinationResults = Observable.from(configure(tabBarController: tabBarController, withTabs: tabs)).merge()

        self.viewDelegate = SplitViewDelegate(splitViewController: splitViewController,
                                              tabBarController: tabBarController)

        window.rootViewController = splitViewController
        window.makeKeyAndVisible()

        return coordinationResults
    }

    private func configure(tabBarController: UITabBarController, withTabs tabs: [SectionTab]) -> [Observable<Void>] {
        let navControllers = tabs
            .map { tab -> UINavigationController in
                let navController = NavigationController()
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
                case .albums:
                    let coordinator = AlbumsCoordinator(navigationController: navCtrl, dependencies: dependencies)
                    return coordinate(to: coordinator)
                case .todos:
                    let coordinator = TodosCoordinator(navigationController: navCtrl, dependencies: dependencies)
                    return coordinate(to: coordinator)
                case .profile:
                    let coordinator = ProfileCoordinator(navigationController: navCtrl, dependencies: dependencies)
                    return coordinate(to: coordinator)
                }
            }
    }

}
