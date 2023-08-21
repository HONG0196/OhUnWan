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
    
    // AuthService의 인스턴스를 주입받아 초기화
    init(authService: AuthService = AuthService.shared) {
        self.authService = authService
    }
    
    // 현재 로그인한 사용자 정보 가져오기
    func getCurrentUser(completion: @escaping (Result<User?, Error>) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            completion(.success(currentUser))
        } else {
            completion(.failure(ProfileError.userNotFound))
        }
    }
    
    // 사용자 프로필 업데이트하기
    func updateUserProfile(newName: String?, newImageURL: URL?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(ProfileError.userNotFound))
            return
        }
        
        // AuthService의 메서드를 사용하여 사용자 프로필 업데이트하기
        authService.updateUserProfile(uid: currentUser.uid, displayName: newName ?? currentUser.displayName ?? "", profileImageURL: newImageURL) { result in
            completion(result)
        }
    }
    
    // 변경 사항을 서버에 반영하기 위한 메서드
    private func commitChanges(changeRequest: UserProfileChangeRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        changeRequest.commitChanges { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}

enum ProfileError: Error {
    case userNotFound
}

// ProfileViewModel에 추가된 메서드
extension ProfileViewModel {
    // 사용자 프로필 업데이트와 이미지 업로드를 처리하는 메서드
    func uploadAndSaveUserProfile(newName: String?, newImage: UIImage, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            // 현재 사용자 정보를 찾지 못한 경우 실패 결과 반환
            completion(.failure(ProfileError.userNotFound))
            return
        }
        
        // 이미지 업로드
        authService.uploadProfileImage(image: newImage, uid: currentUser.uid) { [weak self] result in
            switch result {
            case .success(let imageURL):
                // 사용자 프로필 업데이트
                self?.updateUserProfile(newName: newName, newImageURL: imageURL, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
