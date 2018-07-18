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

final class PostsListViewController: TableViewController, ViewModelAttaching {

    var viewModel: Attachable<PostsListViewModel>!
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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        title = "Posts"
    }

    func bind(viewModel: PostsListViewModel) -> PostsListViewModel {
        viewModel.posts
            .drive(tableView.rx.items(cellIdentifier: PostTableViewCell.reuseID, cellType: PostTableViewCell.self)) { _, viewModel, cell in
                cell.bind(to: viewModel)
            }
            .disposed(by: disposeBag)

        viewModel.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)

        viewModel.errors
            .delay(0.1)
            .map { $0.localizedDescription }
            .drive(errorAlert)
            .disposed(by: disposeBag)

        return viewModel
    }

}
