//
//  PhotoDetailViewController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/11/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class PhotoDetailViewController: UIViewController {

    let disposeBag = DisposeBag()
    var viewModel: PhotoViewModel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.title
            .drive(self.rx.title)
            .disposed(by: disposeBag)

        viewModel.image
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.fetching
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }

}
