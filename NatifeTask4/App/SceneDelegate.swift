//
//  SceneDelegate.swift
//  NatifeTask4
//
//  Created by Nazar on 01.04.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (
            scene as? UIWindowScene
        ) else {
            return
        }

        let container = DIContainer()
        let navigationController = UINavigationController(
            rootViewController: PostsListAssembly.build(
                container: container
            )
        )

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
