//
//  SceneDelegate.swift
//  GradientAnimation
//
//  Created by Наиль Буркеев on 25.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        let vc = ViewController()
        navigationController.pushViewController(vc, animated: true)
    }

}

