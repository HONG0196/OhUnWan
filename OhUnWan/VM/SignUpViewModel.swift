//
//  SignUpViewModel.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/04.
//

import UIKit

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
    
    // 회원가입 요청 메서드
    func signUp(with email: String, password: String, completion: @escaping (Bool) -> Void) {
        // 입력값의 유효성 검사를 수행합니다.
        guard isValidEmail(email) && isValidPassword(password) else {
            signUpStatus = .validationFailed
            completion(false)
            return
        }
        
        // 서버에 회원가입 요청을 보내고, 결과를 받아와서 처리합니다.
        // 여기서는 가상의 회원가입 메서드를 호출하는 것으로 가정하겠습니다.
        APIService.shared.signUpTest(username: email, password: password) { [unowned self] result in
            switch result {
            case .success():
                signUpStatus = .signUpSuccess
                completion(true)
            case .failure(_):
                signUpStatus = .signUpFailed
                completion(false)
            }
        }
    }
    
    // 이메일 유효성 검사
    private func isValidEmail(_ email: String) -> Bool {
        // 이메일 유효성 검사 로직을 구현해야 합니다.
        // 여기서는 간단하게 입력값이 이메일 형식을 만족하는지만 확인합니다.
        return email.contains("@")
    }
    
    // 비밀번호 유효성 검사
    private func isValidPassword(_ password: String) -> Bool {
        // 비밀번호 유효성 검사 로직을 구현해야 합니다.
        // 여기서는 간단하게 입력값의 길이가 확인합니다.
        return password.count >= 1
    }
}
