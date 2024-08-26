//
//  TodoListForTestTests.swift
//  TodoListForTestTests
//
//  Created by Даниил on 26.08.2024.
//

import XCTest
@testable import TodoListForTest

final class MockInteractor: ITodoListInteractor {
    
    var presenter: ITodoListPresenter
    var coreManager: ICoreDataManager
    
    init(presenter: ITodoListPresenter, coreManager: ICoreDataManager) {
        self.presenter = presenter
        self.coreManager = coreManager
    }
    
    func fetchData() {
        let objects = self.coreManager.fetchItem()
        self.presenter.present(items: objects)
    }
    
    func deleteAll() {
        self.presenter.present(items: [])
    }
    
    func updateTask(item: TodoListForTest.Todo, body: String, completed: Bool) {
        self.coreManager.updateItem(item: item, todo: body, completed: completed)
        let objects = self.coreManager.fetchItem()
        self.presenter.present(items: objects)
    }
    
    func saveTask(id: Int, body: String) {
        self.coreManager.addItem(
            id: id,
            completed: false,
            todo: body
        )
        let objects = self.coreManager.fetchItem()
        self.presenter.present(items: objects)
    }
    
    func deleteItem(id: Int) {
        self.coreManager.deleteitem(id: id)
        let objects = self.coreManager.fetchItem()
        self.presenter.present(items: objects)
    }
    
    func addTask() {
        self.presenter.addTask()
    }
    
    func editTask(indexPatch: Int) {
        self.presenter.editTask(indexPatch: indexPatch)
    }
}

final class MockPresenter: ITodoListPresenter {
    
    var view: ITodoListView
    
    init(view: ITodoListView) {
        self.view = view
    }
    
    func present(items: [TodoListForTest.Entity]) {
        self.view.render(items: self.conversion(entity: items))
    }
    
    func addTask() {
        self.view.openAlertCreateTask()
    }
    
    func editTask(indexPatch: Int) {
        self.view.editTask(indexPatch: indexPatch)
    }
    
    func showErrorAlert(text: String) {
        // Show error alert load
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

final class MockView: ITodoListView {
    
    var items: [TodoListForTest.Todo] = []
    
    var interactor: ITodoListInteractor?
    
    init() {
        self.interactor?.fetchData()
    }
    
    func render(items: [TodoListForTest.Todo]) {
        self.items = items
    }
    
    func openAlertCreateTask() {
        // Open alert create task
    }
    
    func editTask(indexPatch: Int) {
        // Open alert edit task
    }
    
    func renderAlertError(text: String) {
        // Show alerrt error load
    }
}

final class TodoListForTestTests: XCTestCase {
    
    var sut: MockView!
    var sutPresenet: MockPresenter!
    var sutInteractor: MockInteractor!
    var coreManager: ICoreDataManager!

    override func setUpWithError() throws {
        sut = MockView()
        sutPresenet = MockPresenter(view: sut)
        coreManager = CoreDataManager()
        coreManager.deleteAll()
        sutInteractor = MockInteractor(presenter: sutPresenet, coreManager: coreManager)
        sut.interactor = sutInteractor
    }

    override func tearDownWithError() throws {
        self.coreManager.deleteAll()
        sut = nil
        sutPresenet = nil
        sutInteractor = nil
        coreManager = nil
    }

    func testModuleIsNotNil() throws {
        XCTAssertNotNil(sut, "View nil")
        XCTAssertNotNil(sutPresenet, "Presenter nil")
        XCTAssertNotNil(sutInteractor, "Interactor nil")
        XCTAssertNotNil(sut.interactor, "Link interactor nil")
    }
    
    func testFetchAllTaskNotEqual() {
        let emprtyTodos: [Todo] = []
        sut.interactor?.fetchData()
        XCTAssertNotEqual(emprtyTodos, sut.items)
    }
    
    func testDeleteAllTrue() {
        let emprtyTodos: [Todo] = []
        sut.interactor?.fetchData()
        sut.interactor?.deleteAll()
        XCTAssertEqual(emprtyTodos, sut.items)
    }
    
    func testSaveTaskTrue() {
        let todo = Todo(id: 20, todo: "20", completed: false, userID: 20)
        sut.interactor?.saveTask(id: todo.id, body: todo.todo)
        let item = sut.items.first { $0.id == todo.id }
        XCTAssertNotNil(item)
    }
    
    func testDeleteItemNil() {
        let todo = Todo(id: 20, todo: "20", completed: false, userID: 20)
        sut.interactor?.saveTask(id: todo.id, body: todo.todo)
        sut.interactor?.deleteItem(id: todo.id)
        let item = sut.items.first { $0.id == todo.id }
        XCTAssertNil(item)
    }
    
    func testUpdateTaskEqual() {
        let todo = Todo(id: 20, todo: "20", completed: false, userID: 20)
        let newBody = "90"
        let newStatus = true
        sut.interactor?.saveTask(id: todo.id, body: todo.todo)
        sut.interactor?.updateTask(item: todo, body: newBody, completed: newStatus)
        let newTodo = sut.items.first { $0.id == todo.id }
        XCTAssertEqual(todo.id, newTodo?.id)
        XCTAssertEqual(todo.todo, newTodo?.todo)
        
    }
}
