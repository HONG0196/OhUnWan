//
//  AppDelegate.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/02.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func showLoginScreen() {
        if let tabBarController = self.window?.rootViewController as? TabBarController {
            // 로그인 화면을 표시하고 첫 번째 탭으로 변경
            tabBarController.selectedIndex = 0
            tabBarController.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        showLoginScreen()
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
    
    
}

