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
    
    var todos: [Todo] = []
    
    init(presenter: ITodoListPresenter) {
        self.presenter = presenter
    }
    
    func fetchData() {
        self.presenter.present(items: todos)
    }
    
    func deleteAll() {
        self.presenter.present(items: [])
    }
    
    func updateTask(item: TodoListForTest.Todo, body: String, completed: Bool) {
        for index in 0...todos.count - 1 {
            var object = todos[index]
            if object.id == item.id {
                object.todo = body
                object.completed = completed
            }
        }
        self.presenter.present(items: todos)
    }
    
    func saveTask(id: Int, body: String) {
        let item = Todo(id: id, todo: body, completed: false, userID: id)
        self.todos.append(item)
        self.presenter.present(items: todos)
    }
    
    func deleteItem(id: Int) {
        for index in 0...todos.count - 1 {
            let item = todos[index]
            if item.id == id {
                self.todos.remove(at: index)
            }
        }
        self.presenter.present(items: todos)
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
    
    func present(items: [TodoListForTest.Todo]) {
        self.view.render(items: items)
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

    override func setUpWithError() throws {
        var todos = [
            Todo(id: 10, todo: "10", completed: true, userID: 10)
        ]
        sut = MockView()
        sutPresenet = MockPresenter(view: sut)
        sutInteractor = MockInteractor(presenter: sutPresenet)
        sutInteractor.todos = todos
        sut.interactor = sutInteractor
    }

    override func tearDownWithError() throws {
        sut = nil
        sutPresenet = nil
        sutInteractor = nil
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
        
        XCTAssertEqual(todo.todo, newTodo?.todo)
        XCTAssertEqual(todo.id, newTodo?.id)
    }
}
