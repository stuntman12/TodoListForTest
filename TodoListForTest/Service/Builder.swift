//
//  Builder.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import UIKit

final class Builder {
    private let network: INetworkManager
    private let coreManager: ICoreDataManager
    
    init(network: INetworkManager, coreManager: ICoreDataManager) {
        self.network = network
        self.coreManager = coreManager
    }
    
    func assemblyTodoList(router: IRouter) -> UIViewController {
        let vc = TodoListView(router: router)
        let presenter = TodoListPresenter(view: vc)
        let interactor = TodoListInteractor(
            presenter: presenter,
            network: self.network,
            coreManager: self.coreManager
        )
        vc.interactor = interactor
        return vc
    }
}
