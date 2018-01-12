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

    //let titleString: String
    let title: Driver<String>
    let thumbnail: Driver<UIImage?>
    //let image: Driver<UIImage?>

    private let photo: Photo

    init(client: APIClient, photo: Photo) {
        self.photo = photo
        //self.titleString = photo.title
        self.title = Driver.just(photo.title)
        self.thumbnail = client.getThumbnail(for: photo)
            .asDriverOnErrorJustComplete()
        //self.image = client.getImage(for: photo)
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

    // equatable, this is needed to detect changes
    static func == (lhs: PhotoViewModel, rhs: PhotoViewModel) -> Bool {
        return lhs.photo.id == rhs.photo.id
    }

}
