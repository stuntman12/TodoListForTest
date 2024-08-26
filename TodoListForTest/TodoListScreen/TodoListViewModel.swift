//
//  TodoListViewModel.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import Foundation

// MARK: - ToDoListModel
struct TodoListViewModel: Hashable, Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

// MARK: - Todo
struct Todo: Hashable, Codable, Identifiable {
    let id: Int
    var todo: String
    var completed: Bool
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
