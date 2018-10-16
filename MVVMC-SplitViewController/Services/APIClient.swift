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

class APIClient: ClientType {

    // MARK: Properties

    private let sessionManager: SessionManager
    private let decoder: JSONDecoder

    private let queue = DispatchQueue(label: "com.mgacy.response-queue", qos: .userInitiated, attributes: [.concurrent])

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

    // MARK: Methods

    func request<M: Codable>(_ endpoint: URLRequestConvertible) -> Single<M> {
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

    func requestImage(_ endpoint: URLRequestConvertible) -> Single<UIImage> {
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

extension ClientError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .imageDecodingFailed:
            return "Unable to decode image"
        }
    }
}
