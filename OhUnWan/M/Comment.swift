//
//  Comment.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/25.
//

import Foundation

struct Comment: Codable {
    let text: String
    let uid: String
    let timestamp: TimeInterval
    
    enum CodingKeys: String, CodingKey {
        case text
        case uid
        case timestamp
    }
    
    init(text: String, uid: String, timestamp: TimeInterval) {
        self.text = text
        self.uid = uid
        self.timestamp = timestamp
    }
}
