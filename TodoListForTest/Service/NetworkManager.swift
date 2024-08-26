//
//  NetworkManager.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import Foundation

typealias CompletionResult = (Result<TodoListViewModel, Error>) -> Void

enum Links: String {
    case todo = "https://dummyjson.com/todos"
}

enum ErrorNetwork: Error, LocalizedError {
    case notUrl
    case notData
    case errorDecoder
    
    var errorDescription: String? {
        switch self {
        case .notUrl:
            return "Не удалось создать ссылку"
        case .notData:
            return "Не пришли данные"
        case .errorDecoder:
            return "Не удалось декодировать данные"
        }
    }
}

protocol INetworkManager {
    func fetchDataToDoList(completion: @escaping CompletionResult)
}

final class NetworkManager: INetworkManager {
    
    func fetchDataToDoList(completion: @escaping CompletionResult) {
        guard let url = URL(string: Links.todo.rawValue) else { return completion(.failure(ErrorNetwork.notUrl)) }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return completion(.failure(ErrorNetwork.notData))}
            
            do {
                let items = try JSONDecoder().decode(TodoListViewModel.self, from: data)
                completion(.success(items))
            } catch {
                completion(.failure(ErrorNetwork.errorDecoder))
            }
        }.resume()
    }
}
