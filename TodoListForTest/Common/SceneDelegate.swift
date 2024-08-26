//
//  SceneDelegate.swift
//  TodoListForTest
//
//  Created by Даниил on 25.08.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let coreManager = CoreDataManager()
        let network = NetworkManager()
        let builder = Builder(network: network, coreManager: coreManager)
        let navigation = UINavigationController()
        let router = Router(navigationController: navigation, builder: builder)
        router.startViewController()
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
    }
}

