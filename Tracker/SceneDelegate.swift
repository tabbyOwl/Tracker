//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Svetlana on 2026/1/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: scene)
        
        let isOnboardingShown = UserDefaults.standard.bool(forKey: UserDefaultsKeys.onboardingShown)
        self.window = window
        if isOnboardingShown {
            window.rootViewController = TabBarController()
        } else {
            window.rootViewController = OnboardingPageViewController()
        }
        
        window.makeKeyAndVisible()
    }
}
