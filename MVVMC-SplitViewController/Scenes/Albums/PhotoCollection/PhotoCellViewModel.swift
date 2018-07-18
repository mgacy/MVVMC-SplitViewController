//
//  PhotoCellViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/11/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Differentiator
import RxCocoa
import RxSwift

final class PhotoCellViewModel {

    let title: Driver<String>
    let thumbnail: Driver<UIImage>
    let photo: Photo

    init(albumService: AlbumServiceType, photo: Photo) {
        self.photo = photo
        self.title = Driver.just(photo.title)
        self.thumbnail = albumService.getThumbnail(for: photo)
            .asDriver(onErrorDriveWith: .empty())
    }

}

// MARK: - RxDataSources - AnimatableSectionModelType

extension PhotoCellViewModel: IdentifiableType {
    typealias Identity = Int

    var identity: Int {
        return photo.id
    }
}

extension PhotoCellViewModel: Equatable {

    static func == (lhs: PhotoCellViewModel, rhs: PhotoCellViewModel) -> Bool {
        return lhs.photo.id == rhs.photo.id
    }

}
