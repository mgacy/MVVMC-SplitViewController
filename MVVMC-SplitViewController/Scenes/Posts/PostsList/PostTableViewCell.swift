//
//  PostTableViewCell.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/16/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    private(set) var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func bind(to viewModel: PostDetailViewModel) {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.body
            .drive(bodyLabel.rx.text)
            .disposed(by: disposeBag)
    }

}
