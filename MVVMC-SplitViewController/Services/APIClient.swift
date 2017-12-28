//
//  APIClient.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import Alamofire
import CodableAlamofire
import RxSwift

class APIClient {

    // MARK: Properties

    private let sessionManager: SessionManager
    private let decoder: JSONDecoder

    private let queue = DispatchQueue(label: "com.mgacy.response-queue", qos: .utility, attributes: [.concurrent])

    // MARK: Lifecycle

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 8  // seconds
        configuration.timeoutIntervalForResource = 8 // seconds
        sessionManager = Alamofire.SessionManager(configuration: configuration)

        // JSON Decoding
        decoder = JSONDecoder()
        //decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: Private

    private func requestOne<M: Codable>(_ endpoint: Router) -> Observable<M> {
        return Observable<M>.create { [unowned self] observer in
            let request = self.sessionManager.request(endpoint)
            request
                .validate()
                .responseDecodableObject(queue: self.queue, decoder: self.decoder) { (response: DataResponse<M>) in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        //print("\(#function) FAILED : \(error)")
                        observer.onError(error)
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    private func requestCollection<M: Codable>(_ endpoint: Router) -> Observable<[M]> {
        return Observable<[M]>.create { [unowned self] observer in
            let request = self.sessionManager.request(endpoint)
            request
                .validate()
                .responseDecodableObject(queue: self.queue, decoder: self.decoder) { (response: DataResponse<[M]>) in
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):
                        //print("\(#function) FAILED : \(error)")
                        observer.onError(error)
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

}

// MARK: - Posts

extension APIClient {

    func getPosts() -> Observable<[Post]> {
        return requestCollection(Router.getPosts)
    }

    func getPost(id: Int) -> Observable<Post> {
        return requestOne(Router.getPost(id: id))
    }

}

// MARK: - Todos

extension APIClient {

    func getTodos() -> Observable<[Todo]> {
        return requestCollection(Router.getTodos)
    }

    func getTodo(id: Int) -> Observable<Todo> {
        return requestOne(Router.getTodo(id: id))
    }

}
