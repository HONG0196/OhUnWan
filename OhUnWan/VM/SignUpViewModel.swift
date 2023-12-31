//
//  SignUpViewModel.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/04.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewModel {
    // 회원가입 결과 상태
    enum SignUpStatus {
        case none             // 초기 상태
        case validationFailed // 입력 실패 (유효성 검사 실패)
        case signUpSuccess    // 회원가입 성공
        case signUpFailed     // 회원가입 실패
    }
    
    
    // 회원가입 상태 데이터 (public으로 변경)
    private(set) var signUpStatus: SignUpStatus = .none
    
    
    
    // 실제 회원가입 요청 메서드
    func signUp(with name: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard isValidName(name),
              isValidEmail(email),
              isValidPassword(password) else {
            signUpStatus = .validationFailed
            completion(false)
            return
        }
        
        // Firebase 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) { [unowned self] authResult, error in
            if let error = error {
                signUpStatus = .signUpFailed
                print("Error signing up: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // 사용자 이름을 Firebase Realtime Database에 저장
            if let user = Auth.auth().currentUser {
                let uid = user.uid
                let userRef = Database.database().reference().child("users").child(uid)
                
                // 사용자 정보 데이터 설정 (프로필 이미지 URL은 빈 문자열로 설정)
                let userData: [String: Any] = [
                    "uid": uid,
                    "displayName": name,
                    "email": email,
                    "profileImageURL": "image.png" // 빈 문자열로 설정
                    // ... 다른 사용자 정보 필드도 추가
                ]
                
                userRef.setValue(userData) { (error, _) in
                    if let error = error {
                        print("Error saving user data: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    
    // 이름 유효성 검사
    private func isValidName(_ name: String) -> Bool {
        // 영어 또는 한글로만 구성되어 있으며 최소 1자 이상
        let namePattern = "^[a-zA-Z가-힣]+$"
        return NSPredicate(format: "SELF MATCHES %@", namePattern).evaluate(with: name)
    }
    
    // 이메일 유효성 검사
    private func isValidEmail(_ email: String) -> Bool {
        // 이메일 유효성 검사 로직을 구현
        // 여기서는 간단하게 입력값이 이메일 형식을 만족하는지만 확인
        return email.contains("@")
    }
    
    // 비밀번호 유효성 검사
    private func isValidPassword(_ password: String) -> Bool {
        // 비밀번호 유효성 검사 로직을 구현
        // 여기서는 간단하게 입력값의 길이가 확인
        return password.count >= 1
    }
}
