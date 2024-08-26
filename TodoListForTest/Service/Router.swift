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
    func showAlertErrorLoad(text: String)
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
    
    func showAlertErrorLoad(text: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: text,
            preferredStyle: .actionSheet
        )
        
        let skipButton = UIAlertAction(
            title: "Ок",
            style: .cancel
        )
        
        alert.addAction(skipButton)
        
        navigationController.present(alert, animated: true)
    }
}
