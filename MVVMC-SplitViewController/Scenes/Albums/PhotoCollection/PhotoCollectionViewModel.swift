//
//  PhotoCollectionViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/9/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift

final class PhotoCollectionViewModel: ViewModelType {

    let fetching: Driver<Bool>
    //let albumTitle: Driver<String>
    let photos: Driver<[PhotoSection]>
    let selectedPhoto: Driver<PhotoViewModel>
    let errors: Driver<Error>

    // MARK: - Lifecycle

    init(dependency: Dependency, bindings: Bindings) {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        photos = bindings.fetchTrigger
            .asObservable()
            .flatMapLatest { _ in
                return dependency.client.getPhotos()
            }
            .map { photo in
                return photo.map {
                    return PhotoViewModel.init(client: dependency.client, photo: $0)
                }
            }
            .map {
                return [PhotoSection(header: dependency.album.title, photos: $0)]
            }
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()

        fetching = activityIndicator.asDriver()
        errors = errorTracker.asDriver()
        selectedPhoto = bindings.selection
            .withLatestFrom(self.photos) { (indexPath, sections: [PhotoSection]) -> PhotoViewModel in
                return sections[indexPath.section].items[indexPath.row]
            }
    }

    // MARK: - ViewModelType

    struct Dependency {
        let client: APIClient
        let album: Album
    }

    struct Bindings {
        let fetchTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }

}
