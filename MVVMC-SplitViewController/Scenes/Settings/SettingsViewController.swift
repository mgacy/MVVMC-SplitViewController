//
//  SettingsViewController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/4/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SettingsViewController: UITableViewController, AttachableType {

    lazy var bindings: SettingsViewModel.Bindings = {
        return SettingsViewModel.Bindings(
            selection: tableView.rx.itemSelected.asDriver()
        )
    }()

    let disposeBag = DisposeBag()
    var viewModel: Attachable<SettingsViewModel>!

    // MARK: - Interface

    private let cellIdentifier = "Cell"

    @IBOutlet weak var accountCell: UITableViewCell!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        title = "Settings"
    }

    func bind(viewModel: SettingsViewModel) -> SettingsViewModel {
        viewModel.didLogout
            .drive()
            .disposed(by: disposeBag)

        viewModel.accountCellText
            .drive(accountCell.textLabel!.rx.text)
            .disposed(by: disposeBag)

        return viewModel
    }

}

extension SettingsViewController {

    func setupTableView() {
        // Necessary w/ RxCocoa since UITableViewController automatically sets tableview delegate and dataSource to self
        tableView.delegate = nil
        tableView.dataSource = nil

        tableView.tableFooterView = UIView() // Prevent empty rows
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

}
