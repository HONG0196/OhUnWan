//
//  ProfileViewModel.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/18.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import UIKit
import SDWebImage

class ProfileViewModel {
    private let authService: AuthService
    
    // 사용자 정보를 저장할 프로퍼티
    var user: User?
    
    // AuthService의 인스턴스를 주입받아 초기화
    init(authService: AuthService = AuthService.shared) {
        self.authService = authService
    }
    
    // 사용자 프로필 업로드
        func uploadUserProfile(displayName: String, profileImage: UIImage, completion: @escaping (Error?) -> Void) {
            guard let uid = user?.uid else {
                completion(NSError(domain: "com.yourapp", code: -1, userInfo: nil))
                return
            }
            
            authService.uploadProfileImage(image: profileImage, uid: uid) { [weak self] result in
                switch result {
                case .success(let profileImageURL):
                    self?.updateUserProfile(displayName: displayName, profileImageURL: profileImageURL, completion: completion)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    
    // 사용자 프로필 업데이트
    func updateUserProfile(displayName: String, profileImageURL: URL, completion: @escaping (Error?) -> Void) {
        guard let uid = user?.uid else {
            completion(NSError(domain: "com.yourapp", code: -1, userInfo: nil))
            return
        }
        
        authService.updateUserProfile(uid: uid, displayName: displayName, profileImageURL: profileImageURL) { error in
            if let error = error {
                print("Error updating user profile:", error)
            }
            completion(error)
        }
    }
    
    // 사용자 정보 가져오기
       func fetchUser(completion: @escaping (Bool) -> Void) {
           let currentUserUID = authService.getCurrentUserUID()
           
           authService.fetchUsers { [weak self] users, error in
               if let error = error {
                   print("Error fetching users:", error)
                   completion(false)
                   return
               }
               
               // Find the user you need using appropriate criteria
               if let currentUser = users.first(where: { $0.uid == currentUserUID }) {
                   self?.user = currentUser
                   completion(true)
               } else {
                   completion(false)
               }
           }
       }
}

