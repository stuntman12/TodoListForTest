//
//  TodoListInteractor.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import Foundation

protocol ITodoListInteractor {
    func fetchData()
    func deleteAll()
    func updateTask(item: Todo, body: String, completed: Bool)
    func saveTask(id: Int, body: String)
    func deleteItem(id: Int)
    func addTask()
    func editTask(indexPatch: Int)
}

final class TodoListInteractor: ITodoListInteractor {
    private let presenter: ITodoListPresenter
    private let network: INetworkManager
    private let coreManager: ICoreDataManager
    
    init(presenter: ITodoListPresenter, network: INetworkManager, coreManager: ICoreDataManager) {
        self.presenter = presenter
        self.network = network
        self.coreManager = coreManager
    }
    
    func fetchData() {
        let objects = self.coreManager.fetchItem()
        if objects.isEmpty {
            dump("Из сети")
            network.fetchDataToDoList { [unowned self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.coreManager.addItems(items: data.todos)
                        let items = self.coreManager.fetchItem()
                        self.presenter.present(items: self.conversion(entity: items))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.presenter.showErrorAlert(text: error.localizedDescription)
                    }
                }
            }
        } else {
            self.presenter.present(items: self.conversion(entity: objects))
        }
    }
    
    func deleteAll() {
        self.coreManager.deleteAll()
        let objects = self.coreManager.fetchItem()
        self.presenter.present(items: self.conversion(entity: objects))
    }
    
    func updateTask(item: Todo, body: String, completed: Bool) {
        self.coreManager.updateItem(item: item, todo: body, completed: completed)
        let objects = self.coreManager.fetchItem()
        self.presenter.present(items: self.conversion(entity: objects))
    }

    
    func deleteItem(id: Int) {
        self.coreManager.deleteitem(id: id)
        let objects = self.coreManager.fetchItem()
        self.presenter.present(items: self.conversion(entity: objects))
    }

    
    func saveTask(id: Int, body: String) {
        self.coreManager.addItem(
            id: id,
            completed: false,
            todo: body
        )
        let objects = self.coreManager.fetchItem()
        self.presenter.present(items: self.conversion(entity: objects))
    }
    
    func addTask() {
        self.presenter.addTask()
    }
    
    func editTask(indexPatch: Int) {
        self.presenter.editTask(indexPatch: indexPatch)
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
