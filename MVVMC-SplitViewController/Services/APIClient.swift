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

    private func request<M: Codable>(_ endpoint: URLRequestConvertible) -> Observable<M> {
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
                        observer.onError(error)
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    private func requestImage(_ endpoint: URLRequestConvertible) -> Observable<UIImage> {
        return Observable<UIImage>.create { [unowned self] observer in
            let request = self.sessionManager.request(endpoint)
            request
                .responseData { response in
                    switch response.result {
                    case .success(let value):
                        guard let image = UIImage(data: value) else {
                            observer.onError(ClientError.imageDecodingFailed)
                            return
                        }

                        observer.onNext(image)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
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

    func getAlbums() -> Observable<[Album]> {
        return request(Router.getAlbums)
    }

    func getAlbum(id: Int) -> Observable<Album> {
        return request(Router.getAlbum(id: id))
    }

}

// MARK: - Photos

extension APIClient {

    func getPhotos() -> Observable<[Photo]> {
        return request(Router.getPhotos)
    }

    func getPhotosFromAlbum(id: Int) -> Observable<[Photo]> {
        return request(Router.getPhotosFromAlbum(id: id))
    }

    func getPhoto(id: Int) -> Observable<Photo> {
        return request(Router.getPhoto(id: id))
    }

    func getThumbnail(for photo: Photo) -> Observable<UIImage> {
        return requestImage(URLRequest(url: photo.thumbnailUrl))
    }

    func getImage(for photo: Photo) -> Observable<UIImage> {
        return requestImage(URLRequest(url: photo.url))
    }

}

// MARK: - Posts

extension APIClient {

    func getPosts() -> Observable<[Post]> {
        return request(Router.getPosts)
    }

    func getPost(id: Int) -> Observable<Post> {
        return request(Router.getPost(id: id))
    }

}

// MARK: - Todos

extension APIClient {

    func getTodos() -> Observable<[Todo]> {
        return request(Router.getTodos)
    }

    func getTodo(id: Int) -> Observable<Todo> {
        return request(Router.getTodo(id: id))
    }

}

// MARK: - Users

extension APIClient {

    func getUser(id: Int) -> Observable<User> {
        return request(Router.getUser(id: id))
    }

}
