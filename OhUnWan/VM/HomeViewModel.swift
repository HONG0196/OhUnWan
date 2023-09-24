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
    var posts: [Post] = [] // 게시물 데이터를 저장할 배열
    var users: [User] = [] // 사용자 데이터를 저장할 배열
    var likedPostIDs: [String] = [] // 사용자가 좋아요한 게시물 ID 목록
    
    init() {
        databaseRef = Database.database().reference()
    }
    
    // 게시물과 사용자 데이터 가져오기
    func fetchData(completion: @escaping (Error?) -> Void) {
        let group = DispatchGroup()
        var fetchErrors: [Error] = [] // 모든 오류를 저장할 배열
        
        // 게시물 데이터 가져오기
        group.enter()
        APIService.shared.fetchPosts { [weak self] fetchedPosts, error in
            if let error = error {
                fetchErrors.append(error)
            } else {
                self?.posts = fetchedPosts
            }
            group.leave()
        }
        
        // 사용자 데이터 가져오기
        group.enter()
        AuthService.shared.fetchUsers { [weak self] fetchedUsers, error in
            if let error = error {
                fetchErrors.append(error)
            } else {
                self?.users = fetchedUsers
            }
            group.leave()
        }
        
        // 모든 데이터가 가져와진 후 호출될 클로저
        group.notify(queue: .main) {
            if fetchErrors.isEmpty {
                // 모든 데이터가 성공적으로 가져왔을 때
                completion(nil)
            } else {
                // 오류가 하나라도 있을 때
                let combinedError = NSError(domain: "com.yourapp.error", code: 0, userInfo: [
                    NSLocalizedDescriptionKey: "Failed to fetch data.",
                    NSLocalizedFailureReasonErrorKey: fetchErrors.map { $0.localizedDescription }.joined(separator: "\n")
                ])
                completion(combinedError)
            }
            self.updateUIWithFetchedData() // 모든 데이터를 가져온 후에 업데이트
        }
    }
    
    // 데이터를 업데이트하고 UI를 업데이트하는 메서드
    func updateUIWithFetchedData() {
        // 테이블 뷰 업데이트 로직
        NotificationCenter.default.post(name: Notification.Name("DataUpdatedNotification"), object: nil)
    }
    
    // 특정 게시물에 대한 사용자 정보 가져오기
    func userForPost(at index: Int) -> User? {
        let post = posts[index]
        if let user = users.first(where: { $0.uid == post.uid }) {
            return user
        }
        return nil
    }
}
