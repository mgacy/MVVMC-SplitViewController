//
//  PostDetailViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift

final class PostDetailViewModel {
    let title: Driver<String>
    let body: Driver<String>
    let post: Post

    // MARK: - Lifecycle

    init(post: Post) {
        self.post = post
        self.title = Observable.just(post.title).asDriver(onErrorJustReturn: "Error")
        self.body = Observable.just(post.body).asDriver(onErrorJustReturn: "Error")
    }

}
