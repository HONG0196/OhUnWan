//
//  HomeViewModel.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/04.
//

import Foundation

class HomeViewModel {
    
    // 데이터 (모델)
    private var userEmail: String
    
    // Output
    var userEmailString: String {
        return userEmail
    }
    
    init(userEmail: String) {
        self.userEmail = userEmail
    }
    
    // Logic...
    
}
