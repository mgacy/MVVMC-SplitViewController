//
//  PhotoDetailViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 2/22/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift

final class PhotoDetailViewModel {

    let fetching: Driver<Bool>
    let errors: Driver<Error>
    let title: Driver<String>
    let image: Driver<UIImage>

    private let photo: Photo

    init(albumService: AlbumServiceType, photo: Photo) {
        self.photo = photo

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        self.title = Driver.just(photo.title)

        self.image = albumService.getImage(for: photo)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()

        fetching = activityIndicator.asDriver()
        errors = errorTracker.asDriver()
    }

}
