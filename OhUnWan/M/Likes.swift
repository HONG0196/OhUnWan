//
//  Likes.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/25.
//

import Foundation

struct Likes: Codable {
    var usersLiked: [String]
    
    init(usersLiked: [String]) {
        self.usersLiked = usersLiked
    }
    
    mutating func toggleLike(forPost post: Post, currentUserUID: String) {
        if usersLiked.contains(currentUserUID) {
            // 이미 좋아요를 누른 경우, 좋아요 취소
            usersLiked.removeAll { $0 == currentUserUID }
        } else {
            // 아직 좋아요를 누르지 않은 경우, 좋아요 추가
            usersLiked.append(currentUserUID)
        }
    }
}
