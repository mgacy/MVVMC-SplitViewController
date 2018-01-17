//
//  PostsListViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift

final class PostsListViewModel: ViewModelType {

    let fetching: Driver<Bool>
    let posts: Driver<[PostDetailViewModel]>
    let selectedPost: Driver<Post>
    let errors: Driver<Error>

    // MARK: - Lifecycle

    init(dependency: Dependency, bindings: Bindings) {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        posts = bindings.fetchTrigger
            .flatMapLatest {
                return dependency.client.getPosts()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
                    .map { $0.map(PostDetailViewModel.init) }
            }

        fetching = activityIndicator.asDriver()
        errors = errorTracker.asDriver()
        selectedPost = bindings.selection
            .withLatestFrom(self.posts) { (indexPath, posts: [PostDetailViewModel]) -> Post in
                return posts[indexPath.row].post
        }
    }

    // MARK: - ViewModelType

    typealias Dependency = HasClient

    struct Bindings {
        let fetchTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }

}
