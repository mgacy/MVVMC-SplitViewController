//
//  TodoService.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 2/28/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Alamofire
import RxSwift

protocol TodoServiceType {
    func getTodos() -> Single<[Todo]>
    func getTodo(id: Int) -> Single<Todo>
}

class TodoService: TodoServiceType {
    private let client: ClientType

    init(client: ClientType) {
        self.client = client
    }

    func getTodos() -> Single<[Todo]> {
        return client.request(Router.getTodos)
    }

    func getTodo(id: Int) -> Single<Todo> {
        return client.request(Router.getTodo(id: id))
    }

}
