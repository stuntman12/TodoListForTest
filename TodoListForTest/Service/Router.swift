//
//  Router.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import UIKit

protocol IRouter {
    func startViewController()
    func backView()
    func showAlertCreateTask()
}

final class Router: IRouter {
    private let navigationController: UINavigationController
    private let builder: Builder
    
    init(navigationController: UINavigationController, builder: Builder) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func startViewController() {
        let mainVC = builder.assemblyTodoList(router: self)
        navigationController.viewControllers = [mainVC]
    }
    
    func backView() {
        navigationController.dismiss(animated: true)
    }
    
    func showAlertCreateTask() {
        let alert = UIAlertController(
            title: "Создание",
            message: "Напишите что необходимо сделать",
            preferredStyle: .alert
        )
        
        let saveButton = UIAlertAction(
            title: "Создать",
            style: .default) { _ in
                
            }
        
        alert.addAction(saveButton)
        
        navigationController.present(alert, animated: true)
    }
}
