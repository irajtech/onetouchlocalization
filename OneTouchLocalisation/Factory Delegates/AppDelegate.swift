//
//  AppDelegate.swift
//  OneTouchLocalisation
//
//  Created by Raj. on 27/02/2021.
//  Copyright © 2020 Raj. All rights reserved.

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let userLanguage = UserSettings.shared.languagesSupported {
            LocalizationManager.setLanguageTo(userLanguage)
        } else {
            LocalizationManager.setLanguageTo("en")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setUpHomeView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeScreenView =  storyboard.instantiateViewController(identifier: "ViewController")
        self.window?.rootViewController = homeScreenView
        self.window?.makeKeyAndVisible()
    }

}

extension AppDelegate: ViewResetable {
    func reset() {

        if let delegate = UIApplication.shared.delegate, let window = delegate.window.unsafelyUnwrapped {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                DispatchQueue.main.async {
                    self.setUpHomeView()
                }
            }, completion: nil)
        }
    }
}
