//
//  TodosListViewModel.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 12/28/17.
//  Copyright © 2017 Mathew Gacy. All rights reserved.
//

import RxCocoa
import RxSwift

final class TodosListViewModel: ViewModelType {

    let fetching: Driver<Bool>
    let todos: Driver<[Todo]>
    let selectedTodo: Driver<Todo>
    let errors: Driver<Error>

    // MARK: - Lifecycle

    init(dependency: Dependency, bindings: Bindings) {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        todos = bindings.fetchTrigger
            .flatMapLatest {
                return dependency.client.getTodos()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }

        fetching = activityIndicator.asDriver()
        errors = errorTracker.asDriver()
        selectedTodo = bindings.selection
            .withLatestFrom(self.todos) { (indexPath, todos: [Todo]) -> Todo in
                return todos[indexPath.row]
        }
    }

    // MARK: - ViewModelType

    typealias Dependency = HasClient

    struct Bindings {
        let fetchTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }

}
