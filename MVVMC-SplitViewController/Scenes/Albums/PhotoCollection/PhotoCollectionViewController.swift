//
//  PhotoCollectionViewController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/9/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

class PhotoCollectionViewController: UIViewController, AttachableType {

    let disposeBag = DisposeBag()

    var viewModel: Attachable<PhotoCollectionViewModel>!
    var bindings: PhotoCollectionViewModel.Bindings {
        return PhotoCollectionViewModel.Bindings(
            selection: collectionView.rx.itemSelected.asDriver()
        )
    }

    private static let reuseIdentifier = "PhotoCell"
    //fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        title = "Photos"
    }

    func bind(viewModel: PhotoCollectionViewModel) -> PhotoCollectionViewModel {
        let (configureCollectionViewCell, configureSupplementaryView) =  PhotoCollectionViewController.collectionViewDataSourceUI()
        let cvDataSource = RxCollectionViewSectionedAnimatedDataSource<PhotoSection>(
            configureCell: configureCollectionViewCell,
            configureSupplementaryView: configureSupplementaryView
        )

        viewModel.photos
            .asObservable()
            .bind(to: collectionView.rx.items(dataSource: cvDataSource))
            .disposed(by: disposeBag)

        viewModel.fetching
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.fetching
            .drive(collectionView.rx.isHidden)
            .disposed(by: disposeBag)

        return viewModel
    }

}

extension PhotoCollectionViewController {

    static func collectionViewDataSourceUI() -> (CollectionViewSectionedDataSource<PhotoSection>.ConfigureCell, CollectionViewSectionedDataSource<PhotoSection>.ConfigureSupplementaryView) {
        return (
            { (_, cv, ip, i) in
                let cell = cv.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: ip) as! PhotoCell
                i.title
                    .drive(cell.titleLabel.rx.text)
                    .disposed(by: cell.disposeBag)

                i.thumbnail
                    .drive(cell.imageView.rx.image)
                    .disposed(by: cell.disposeBag)

                return cell
            },
            { (ds ,cv, kind, ip) in
                let section = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoSectionView",
                                                                  for: ip) as! PhotoSectionView
                section.titleLabel!.text = "\(ds[ip.section].header)"
                return section
            }
        )
    }

}
