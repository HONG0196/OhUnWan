//
//  DetailViewModel.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/16.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

class DetailViewModel {
    private let apiService = APIService.shared
    
    // CREATE: 이미지와 텍스트를 저장하는 메서드
    func saveImageAndText(image: UIImage, text: String, completion: @escaping (Error?) -> Void) {
        apiService.createPost(image: image, text: text, completion: completion)
    }
    
    // UPDATE: 텍스트 수정하는 메서드
    func updatePost(postID: String, newText: String, completion: @escaping (Error?) -> Void) {
        apiService.updatePost(postID: postID, newText: newText, completion: completion)
    }
    
    // DELETE: 데이터 삭제하는 메서드
    func deletePost(postID: String, imageURL: URL, completion: @escaping (Error?) -> Void) {
        apiService.deletePost(postID: postID, imageURL: imageURL, completion: completion)
    }
}
