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
        let homeVC = HomeViewController(viewModel: HomeViewModel())
        let homeNavigationController = UINavigationController(rootViewController: homeVC)
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
        
        viewControllers = [homeNavigationController]
    }
}
