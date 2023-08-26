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
    
    enum CodingKeys: String, CodingKey {
        case text
        case imageURL
        case uid
        case timestamp
    }
    
    init(text: String, imageURL: URL, uid: String, timestamp: TimeInterval) {
        self.text = text
        self.imageURL = imageURL.absoluteString // 이미지 URL을 String으로 저장
        self.uid = uid
        self.timestamp = timestamp
    }
    
    func formattedDate() -> String {
        let postDate = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 원하는 날짜 및 시간 표시 형식 설정
        return dateFormatter.string(from: postDate)
    }
}
