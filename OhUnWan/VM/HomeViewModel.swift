//
//  HomeViewModel.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/04.
//

import Foundation
import Firebase
import FirebaseDatabase

class HomeViewModel {
    
    private var databaseRef: DatabaseReference
    var posts: [Post] = []
    
    init() {
        databaseRef = Database.database().reference()
    }
    
    // Firebase에서 데이터 가져오는 메서드
    func fetchPosts(completion: @escaping () -> Void) {
        databaseRef.child("posts").observe(.value) { [weak self] snapshot in
            var fetchedPosts: [Post] = []
            
            for childSnapshot in snapshot.children {
                if let childSnapshot = childSnapshot as? DataSnapshot,
                   let postDict = childSnapshot.value as? [String: Any],
                   let text = postDict["text"] as? String,
                   let imageURLString = postDict["imageURL"] as? String,
                   let imageURL = URL(string: imageURLString) {
                    
                    let post = Post(text: text, imageURL: imageURL)
                    fetchedPosts.append(post)
                }
            }
            
            // 메인 스레드에서 포스트 배열 업데이트
            DispatchQueue.main.async {
                self?.posts = fetchedPosts
                completion() // 완료 핸들러 호출
            }
        }
    }
}
    
    struct Post {
        let text: String
        let imageURL: URL
    }
    
    
    
    
    
    
