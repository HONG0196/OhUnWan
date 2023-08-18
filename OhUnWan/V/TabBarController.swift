//
//  TabBarController.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/07.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
            // HomeViewController 추가
            let homeVC = HomeViewController(viewModel: HomeViewModel())
            let homeNavigationController = UINavigationController(rootViewController: homeVC)
            homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
            
            // ProfileViewController 추가
            let profileVC = ProfileViewController() 
            let profileNavigationController = UINavigationController(rootViewController: profileVC)
            profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: nil)
            
            // 탭바에 뷰 컨트롤러들 추가
            viewControllers = [homeNavigationController, profileNavigationController]
        }
}
