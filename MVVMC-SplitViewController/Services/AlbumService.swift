//
//  AlbumService.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 2/28/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Alamofire
import RxSwift

protocol AlbumServiceType {
    func getAlbums() -> Single<[Album]>
    func getAlbum(id: Int) -> Single<Album>
    func getPhotos() -> Single<[Photo]>
    func getPhotosFromAlbum(id: Int) -> Single<[Photo]>
    func getPhoto(id: Int) -> Single<Photo>
    func getThumbnail(for photo: Photo) -> Single<UIImage>
    func getImage(for photo: Photo) -> Single<UIImage>
}

class AlbumService: AlbumServiceType {
    private let client: ClientType

    init(client: ClientType) {
        self.client = client
    }

    // MARK: Albums

    func getAlbums() -> Single<[Album]> {
        return client.request(Router.getAlbums)
    }

    func getAlbum(id: Int) -> Single<Album> {
        return client.request(Router.getAlbum(id: id))
    }

    // MARK: Photos

    func getPhotos() -> Single<[Photo]> {
        return client.request(Router.getPhotos)
    }

    func getPhotosFromAlbum(id: Int) -> Single<[Photo]> {
        return client.request(Router.getPhotosFromAlbum(id: id))
    }

    func getPhoto(id: Int) -> Single<Photo> {
        return client.request(Router.getPhoto(id: id))
    }

    func getThumbnail(for photo: Photo) -> Single<UIImage> {
        return client.requestImage(URLRequest(url: photo.thumbnailUrl))
    }

    func getImage(for photo: Photo) -> Single<UIImage> {
        return client.requestImage(URLRequest(url: photo.url))
    }

}
