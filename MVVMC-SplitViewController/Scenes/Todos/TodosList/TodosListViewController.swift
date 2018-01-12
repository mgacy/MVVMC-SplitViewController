//
//  TodosListViewController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class TodosListViewController: TableViewController, ViewModelAttaching {

    var viewModel: Attachable<TodosListViewModel>!
    var bindings: TodosListViewModel.Bindings {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let refresh = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()

        return TodosListViewModel.Bindings(
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
        title = "Todos"
    }

    func bind(viewModel: TodosListViewModel) -> TodosListViewModel {
        viewModel.todos
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
