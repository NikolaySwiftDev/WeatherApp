//
//  SceneDelegate.swift
//  WeaterApp
//
//  Created by Николай on 13.05.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let builder = Builder()
        let navigationController = UINavigationController(rootViewController: builder.createWeatherVC())
        navigationController.setNavigationBarHidden(true, animated: true)
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

