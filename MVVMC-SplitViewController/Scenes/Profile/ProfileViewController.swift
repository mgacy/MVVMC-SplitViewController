//
//  ProfileViewController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/12/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileViewController: UIViewController, ViewModelAttaching {

    var viewModel: Attachable<ProfileViewModel>!
    var bindings: ProfileViewModel.Bindings {
        return ProfileViewModel.Bindings(
            settingsTaps: settingsButtonItem.rx.tap.asDriver()
        )
    }

    let disposeBag = DisposeBag()

    // MARK: Interface

    @IBOutlet weak var settingsButtonItem: UIBarButtonItem!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        avatarView.layer.cornerRadius = 35
        avatarView.clipsToBounds = true
    }

    func bind(viewModel: ProfileViewModel) -> ProfileViewModel {
        viewModel.initials.drive(avatarLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.name.drive(nameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.username.drive(usernameLabel.rx.text)
            .disposed(by: disposeBag)

        return viewModel
    }

}
