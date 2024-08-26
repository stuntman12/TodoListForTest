//
//  TodoListPresenter.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import Foundation

protocol ITodoListPresenter {
    func present(items: [Entity])
    func addTask()
    func editTask(indexPatch: Int)
    func showErrorAlert(text: String)
}

final class TodoListPresenter: ITodoListPresenter {
    private let view: ITodoListView
    
    init(view: ITodoListView) {
        self.view = view
    }
    
    func present(items: [Entity]) {
        view.render(items: self.conversion(entity: items))
    }
    
    func addTask() {
        self.view.openAlertCreateTask()
    }
    
    func editTask(indexPatch: Int) {
        self.view.editTask(indexPatch: indexPatch)
    }
    
    func showErrorAlert(text: String) {
        self.view.renderAlertError(text: text)
    }
    
    func conversion(entity: [Entity]) -> [Todo] {
        let todos = entity.map {
            Todo(
                id: Int($0.id),
                todo: $0.todo,
                completed: $0.completed,
                userID: 0
            )
        }
        return todos
    }

}
