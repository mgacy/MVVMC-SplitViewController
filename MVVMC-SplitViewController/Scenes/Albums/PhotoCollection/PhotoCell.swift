//
//  PhotoCell.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/11/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxSwift

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    private(set) var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag() // because life cicle of every cell ends on prepare for reuse
    }

    func bind(to viewModel: PhotoViewModel) {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.thumbnail
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }

}

// MARK: - SectionView

class PhotoSectionView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel?
}
