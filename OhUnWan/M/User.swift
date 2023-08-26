//
//  User.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/23.
//

import Foundation

struct User: Codable {
    let uid: String // 사용자 식별자
    let displayName: String
    let email: String
    let profileImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case displayName
        case email
        case profileImageURL
    }
    
    init(uid: String, displayName: String, email: String, profileImageURL: String) {
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.profileImageURL = profileImageURL
    }
}
