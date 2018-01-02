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

    // MARK: - Lifecycle

    init(post: Post) {
        title = Observable.just(post.title).asDriver(onErrorJustReturn: "Error")
        body = Observable.just(post.body).asDriver(onErrorJustReturn: "Error")
    }

}
