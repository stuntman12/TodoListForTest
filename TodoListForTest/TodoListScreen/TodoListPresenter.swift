//
//  TodoListPresenter.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import Foundation

protocol ITodoListPresenter {
    func present(items: [Todo])
    func addTask()
    func editTask(indexPatch: Int)
}

final class TodoListPresenter: ITodoListPresenter {
    private let view: ITodoListView
    
    init(view: ITodoListView) {
        self.view = view
    }
    
    func present(items: [Todo]) {
        view.render(items: items)
    }
    
    func addTask() {
        self.view.openAlertCreateTask()
    }
    
    func editTask(indexPatch: Int) {
        self.view.editTask(indexPatch: indexPatch)
    }

}
