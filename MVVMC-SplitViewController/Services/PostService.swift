//
//  PostService.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 2/28/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Alamofire
import RxSwift

protocol PostServiceType {
    func getPosts() -> Single<[Post]>
    func getPost(id: Int) -> Single<Post>
}

class PostService: PostServiceType {
    private let client: ClientType

    init(client: ClientType) {
        self.client = client
    }

    func getPosts() -> Single<[Post]> {
        return client.request(Router.getPosts)
    }

    func getPost(id: Int) -> Single<Post> {
        return client.request(Router.getPost(id: id))
    }

}
