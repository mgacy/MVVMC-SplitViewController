//
//  TableViewController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/8/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxSwift

class TableViewController: UITableViewController {

    let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - View Methods

    func setupTableView() {
        // This is necessary since UITableViewController automatically sets tableview delegate and dataSource to self
        tableView.delegate = nil
        tableView.dataSource = nil

        tableView.tableFooterView = UIView() // Prevent empty rows
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseID)
    }

}

