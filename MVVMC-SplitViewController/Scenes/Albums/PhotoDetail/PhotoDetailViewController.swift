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

    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        title = "Photos"
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.image
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }

}
