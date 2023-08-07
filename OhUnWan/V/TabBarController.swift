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
        
        // 탭에 연결될 뷰 컨트롤러들 생성
        let homeVC = HomeViewController(viewModel: HomeViewModel(userEmail: "user@example.com"))
        // let profileVC = ProfileViewController(viewModel: ProfileViewModel()) // ProfileViewController에 대한 뷰모델 생성
        
        // 뷰 컨트롤러들을 네비게이션 컨트롤러로 래핑
        let homeNavigationController = UINavigationController(rootViewController: homeVC)
        
        // 뷰 컨트롤러들을 탭 바 아이템과 함께 설정
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
        
        // 탭 바 컨트롤러에 네비게이션 컨트롤러들 설정
        viewControllers = [homeNavigationController]
    }
    
}
