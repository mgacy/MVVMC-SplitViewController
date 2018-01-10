//
//  AlbumListViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/9/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift

final class AlbumListViewModel: ViewModelType {

    let fetching: Driver<Bool>
    let albums: Driver<[Album]>
    let selectedAlbum: Driver<Album>
    let errors: Driver<Error>

    // MARK: - Lifecycle

    init(dependency: Dependency, bindings: Bindings) {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        albums = bindings.fetchTrigger
            .flatMapLatest {
                return dependency.client.getAlbums()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }

        fetching = activityIndicator.asDriver()
        errors = errorTracker.asDriver()
        selectedAlbum = bindings.selection
            .withLatestFrom(self.albums) { (indexPath, albums: [Album]) -> Album in
                return albums[indexPath.row]
            }
    }

    // MARK: - ViewModelType

    typealias Dependency = HasClient

    struct Bindings {
        let fetchTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }

}

