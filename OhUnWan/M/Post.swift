//
//  Post.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/23.
//

import Foundation

struct Post: Codable {
    let text: String
    let imageURL: String
    let uid: String
    let timestamp: TimeInterval
    let postID: String
    var likes: Likes // 좋아요 정보를 저장할 구조체 추가
    
    enum CodingKeys: String, CodingKey {
        case text
        case imageURL
        case uid
        case timestamp
        case postID
        case likes // 새로운 좋아요 구조체 추가
    }
    
    init(text: String, imageURL: URL, uid: String, timestamp: TimeInterval, postID: String, likes: Likes) {
        self.text = text
        self.imageURL = imageURL.absoluteString
        self.uid = uid
        self.timestamp = timestamp
        self.postID = postID
        self.likes = likes // 좋아요 정보 초기화
    }
    
    func formattedDate() -> String {
        let postDate = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: postDate)
    }
}
