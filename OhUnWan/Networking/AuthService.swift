//
//  AuthService.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/21.
//

import FirebaseAuth
import FirebaseStorage
import UIKit
import FirebaseDatabase

class AuthService {
    // Singleton으로 생성되는 AuthService 클래스
    static let shared = AuthService()
    private init() {}
    private let databaseRef = Database.database().reference()
    
    
    func getCurrentUserUID() -> String? {
        let currentUser = Auth.auth().currentUser
        let uid = currentUser?.uid
        print("Current user UID:", uid)
        return uid
    }

    // MARK: - 프로필 이미지 업로드
    func uploadProfileImage(image: UIImage, uid: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let resizedImageData = image.resizedTo(maxWidth: 800)?.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "com.yourapp", code: -1, userInfo: nil)))
            return
        }
        
        let imageName = "\(uid)_profile.jpg"
        let imageRef = Storage.storage().reference().child("profile_images/\(imageName)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(resizedImageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                imageRef.downloadURL { url, error in
                    if let url = url {
                        completion(.success(url))
                    } else {
                        completion(.failure(NSError(domain: "com.yourapp", code: -1, userInfo: nil)))
                    }
                }
            }
        }
    }
    
    // MARK: - 사용자 이름 가져오기
    func getUserDisplayName(uid: String, completion: @escaping (String?, Error?) -> Void) {
        databaseRef.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let displayName = userData["displayName"] as? String {
                completion(displayName, nil)
            } else {
                completion(nil, NSError(domain: "com.yourapp", code: -1, userInfo: nil))
            }
        }
    }
    
    // MARK: - 프로필 이미지 가져오기
    func getUserProfileImageURL(uid: String, completion: @escaping (URL?, Error?) -> Void) {
        databaseRef.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            if let userData = snapshot.value as? [String: Any],
               let profileImageURLString = userData["profileImageURL"] as? String,
               let profileImageURL = URL(string: profileImageURLString) {
                completion(profileImageURL, nil)
            } else {
                completion(nil, NSError(domain: "com.yourapp", code: -1, userInfo: nil))
            }
        }
    }
    
    // MARK: - 사용자 프로필 업데이트
    func updateUserProfile(uid: String, displayName: String, profileImageURL: URL, completion: @escaping (Error?) -> Void) {
        let userRef = databaseRef.child("users").child(uid)
        let userData: [String: Any] = [
            "displayName": displayName,
            "profileImageURL": profileImageURL.absoluteString
            // ... 다른 사용자 정보 필드도 추가
        ]
        
        userRef.updateChildValues(userData) { error, _ in
            completion(error)
        }
    }
    
    // MARK: - 이메일 가져오기
    func getUserEmail(completion: @escaping (String?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            let email = currentUser.email
            completion(email)
        } else {
            completion(nil)
        }
    }

    
    // MARK: - 사용자 데이터 가져오기
    func fetchUsers(completion: @escaping ([User], Error?) -> Void) {
        databaseRef.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let usersData = snapshot.value as? [String: [String: Any]] else {
                completion([], NSError(domain: "com.yourapp", code: -1, userInfo: nil))
                return
            }
            //print("Fetched usersData:", usersData) // 추가: 데이터 확인용 출력
            var users: [User] = []
            for (uid, userData) in usersData {
                if let displayName = userData["displayName"] as? String,
                   let email = userData["email"] as? String,
                   let profileImageURLString = userData["profileImageURL"] as? String,
                   let profileImageURL = URL(string: profileImageURLString) {
                    let user = User(uid: uid, displayName: displayName, email: email, profileImageURL: profileImageURL.absoluteString)
                    
                    users.append(user)
                }
            }

            // 추가: users 배열에 저장된 사용자 정보 출력
            //print("Fetched users:", users)

            completion(users, nil)
        }
    }



}
