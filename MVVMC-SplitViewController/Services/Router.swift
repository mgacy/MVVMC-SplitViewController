//
//  Router.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import Alamofire

public enum Router: URLRequestConvertible {
    case getPosts
    case getPost(id: Int)
    case getTodos
    case getTodo(id: Int)

    static let baseURLString = "https://jsonplaceholder.typicode.com"

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getPosts:
            return "/posts"
        case .getPost(let id):
            return "/posts/\(id)"
        case .getTodos:
            return "/todos"
        case .getTodo(let id):
            return "/todos/\(id)"
        }
    }

    var parameters: Parameters {
        switch self {
        default:
            return [:]
        }
    }

    // MARK: URLRequestConvertible

    public func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        default:
            break
        }

        return urlRequest
    }

}
