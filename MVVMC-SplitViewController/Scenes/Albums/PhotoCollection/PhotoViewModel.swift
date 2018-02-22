//
//  PhotoViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/11/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import Differentiator
import RxCocoa
import RxSwift

final class PhotoViewModel {

    let fetching: Driver<Bool>
    let errors: Driver<Error>
    let title: Driver<String>
    let thumbnail: Driver<UIImage?>
    let image: Driver<UIImage?>

    private let photo: Photo

    init(client: APIClient, photo: Photo) {
        self.photo = photo

        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        self.title = Driver.just(photo.title)

        self.thumbnail = client.getThumbnail(for: photo)
            .asDriverOnErrorJustComplete()

        self.image = client.getImage(for: photo)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()

        fetching = activityIndicator.asDriver()
        errors = errorTracker.asDriver()
    }

}

// MARK: - RxDataSources - AnimatableSectionModelType

extension PhotoViewModel: IdentifiableType {
    typealias Identity = Int

    var identity: Int {
        return photo.id
    }
}

extension PhotoViewModel: Equatable {

    static func == (lhs: PhotoViewModel, rhs: PhotoViewModel) -> Bool {
        return lhs.photo.id == rhs.photo.id
    }

}
