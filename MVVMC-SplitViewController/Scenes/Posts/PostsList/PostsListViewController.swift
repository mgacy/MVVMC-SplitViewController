//
//  PostsListViewController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/27/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class PostsListViewController: UITableViewController, AttachableType {

    var bindings: PostsListViewModel.Bindings {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let refresh = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()

        return PostsListViewModel.Bindings(
            fetchTrigger: Driver.merge(viewWillAppear, refresh),
            selection: tableView.rx.itemSelected.asDriver()
        )
    }

    let disposeBag = DisposeBag()
    var viewModel: Attachable<PostsListViewModel>!

    private let cellIdentifier = "Cell"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        title = "Posts"
        setupTableView()
    }

    func bind(viewModel: PostsListViewModel) -> PostsListViewModel {
        viewModel.posts
            .drive(tableView.rx.items(cellIdentifier: "Cell")) { _, element, cell in
                cell.textLabel?.text = element.title
            }
            .disposed(by: disposeBag)

        viewModel.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.errors
            .drive(onNext: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)

        return viewModel
    }

}

extension PostsListViewController {

    func setupTableView() {
        // Necessary w/ RxCocoa since UITableViewController automatically sets tableview delegate and dataSource to self
        tableView.delegate = nil
        tableView.dataSource = nil

        tableView.tableFooterView = UIView() // Prevent empty rows
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

}
