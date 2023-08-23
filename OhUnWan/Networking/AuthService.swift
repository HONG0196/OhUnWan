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
    
    // 사용자 등록 및 프로필 이미지 업로드와 업데이트
    func signUp(email: String, password: String, displayName: String, profileImage: UIImage?, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                // 사용자가 이미지를 제공했다면 프로필 이미지를 업로드
                if let profileImage = profileImage {
                    self.uploadProfileImage(image: profileImage, uid: user.uid) { result in
                        switch result {
                        case .success(let imageURL):
                            // 사용자의 프로필 업데이트
                            self.updateUserProfile(uid: user.uid, displayName: displayName, profileImageURL: imageURL) { result in
                                switch result {
                                case .success:
                                    completion(.success(user))
                                case .failure(let error):
                                    completion(.failure(error))
                                }
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    // 사용자의 프로필 업데이트
                    self.updateUserProfile(uid: user.uid, displayName: displayName, profileImageURL: nil) { result in
                        switch result {
                        case .success:
                            completion(.success(user))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    // 프로필 이미지를 Firebase Storage에 업로드
    func uploadProfileImage(image: UIImage, uid: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("profileImages").child("\(uid).jpg")
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    // 이미지 업로드 성공 시 다운로드 URL을 받아서 반환
                    storageRef.downloadURL { url, error in
                        if let downloadURL = url {
                            completion(.success(downloadURL))
                        } else if let error = error {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    // 이름 가져오기
    func getUserDisplayName(completion: @escaping (Result<String?, Error>) -> Void) {
        if let user = Auth.auth().currentUser {
            completion(.success(user.displayName))
        } else {
            completion(.success(nil))
        }
    }
    
    // 프로필 이미지 가져오기
    func getUserProfileImageURL(uid: String, completion: @escaping (Result<URL?, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("profileImages").child("\(uid).jpg")
        
        storageRef.downloadURL { url, error in
            if let downloadURL = url {
                completion(.success(downloadURL))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    // 사용자 프로필 업데이트
    func updateUserProfile(uid: String, displayName: String, profileImageURL: URL?, completion: @escaping (Result<Void, Error>) -> Void) {
        var changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        if let profileImageURL = profileImageURL {
            changeRequest?.photoURL = profileImageURL
        }

        changeRequest?.commitChanges { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // 사용자 프로필 정보 업데이트 및 이미지 업로드 함수 호출
    func updateProfileInfo(uid: String, displayName: String, profileImage: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        if let image = profileImage {
            // 프로필 이미지 업로드 후 사용자 프로필 업데이트
            AuthService.shared.uploadProfileImage(image: image, uid: uid) { result in
                switch result {
                case .success(let imageURL):
                    self.updateUserProfile(uid: uid, displayName: displayName, profileImageURL: imageURL, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            // 이미지가 없을 경우 프로필 정보만 업데이트
            self.updateUserProfile(uid: uid, displayName: displayName, profileImageURL: nil, completion: completion)
        }
    }
    
}
