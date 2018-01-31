//
//  Router.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import Alamofire

public enum Router: URLRequestConvertible {
    case getAlbums
    case getAlbum(id: Int)
    case getPhotos
    case getPhoto(id: Int)
    case getPhotosFromAlbum(id: Int)
    case getPosts
    case getPost(id: Int)
    case getTodos
    case getTodo(id: Int)
    case getUser(id: Int)

    static let baseURLString = "https://jsonplaceholder.typicode.com"

    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getAlbums:
            return "/albums"
        case .getAlbum(let id):
            return "/albums/\(id)"
        case .getPhotos:
            return "/photos"
        case .getPhoto(let id):
            return "/photos/\(id)"
        case .getPhotosFromAlbum:
            return "/photos"
        case .getPosts:
            return "/posts"
        case .getPost(let id):
            return "/posts/\(id)"
        case .getTodos:
            return "/todos"
        case .getTodo(let id):
            return "/todos/\(id)"
        case .getUser(let id):
            return "/users/\(id)"
        }
    }

    var parameters: Parameters {
        switch self {
        case .getPhotosFromAlbum(let id):
            return ["album": id]
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
        case .getPhotosFromAlbum:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }

        return urlRequest
    }

}
