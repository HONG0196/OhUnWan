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
    
    enum CodingKeys: String, CodingKey {
        case text
        case imageURL
        case uid
        case timestamp
        case postID
    }
    
    init(text: String, imageURL: URL, uid: String, timestamp: TimeInterval, postID: String) {
        self.text = text
        self.imageURL = imageURL.absoluteString
        self.uid = uid
        self.timestamp = timestamp
        self.postID = postID // postID 초기화
    }
    
    func formattedDate() -> String {
        let postDate = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: postDate)
    }
}

