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

protocol ClientType {
    func request<T: Codable>(_: URLRequestConvertible) -> Single<T>
    func requestImage(_ endpoint: URLRequestConvertible) -> Single<UIImage>
}

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

    private func request<M: Codable>(_ endpoint: URLRequestConvertible) -> Single<M> {
        return Single<M>.create { [unowned self] single in
            let request = self.sessionManager.request(endpoint)
            request
                .validate()
                .responseDecodableObject(queue: self.queue, decoder: self.decoder) { (response: DataResponse<M>) in
                    switch response.result {
                    case let .success(val):
                        single(.success(val))
                    case let .failure(err):
                        single(.error(err))
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    private func requestImage(_ endpoint: URLRequestConvertible) -> Single<UIImage> {
        return Single<UIImage>.create { [unowned self] single in
            let request = self.sessionManager.request(endpoint)
            request
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let value):
                        guard let image = UIImage(data: value) else {
                            single(.error(ClientError.imageDecodingFailed))
                            return
                        }
                        single(.success(image))
                    case .failure(let err):
                        single(.error(err))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

}

// MARK: - Errors

enum ClientError: Error {
    case imageDecodingFailed
}

// MARK: - Albums

extension APIClient {

    func getAlbums() -> Single<[Album]> {
        return request(Router.getAlbums)
    }

    func getAlbum(id: Int) -> Single<Album> {
        return request(Router.getAlbum(id: id))
    }

}

// MARK: - Photos

extension APIClient {

    func getPhotos() -> Single<[Photo]> {
        return request(Router.getPhotos)
    }

    func getPhotosFromAlbum(id: Int) -> Single<[Photo]> {
        return request(Router.getPhotosFromAlbum(id: id))
    }

    func getPhoto(id: Int) -> Single<Photo> {
        return request(Router.getPhoto(id: id))
    }

    func getThumbnail(for photo: Photo) -> Single<UIImage> {
        return requestImage(URLRequest(url: photo.thumbnailUrl))
    }

    func getImage(for photo: Photo) -> Single<UIImage> {
        return requestImage(URLRequest(url: photo.url))
    }

}

// MARK: - Posts

extension APIClient {

    func getPosts() -> Single<[Post]> {
        return request(Router.getPosts)
    }

    func getPost(id: Int) -> Single<Post> {
        return request(Router.getPost(id: id))
    }

}

// MARK: - Todos

extension APIClient {

    func getTodos() -> Single<[Todo]> {
        return request(Router.getTodos)
    }

    func getTodo(id: Int) -> Single<Todo> {
        return request(Router.getTodo(id: id))
    }

}

// MARK: - Users

extension APIClient {

    func getUser(id: Int) -> Single<User> {
        return request(Router.getUser(id: id))
    }

}
