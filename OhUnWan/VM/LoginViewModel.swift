//
//  LoginViewModel.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/02.
//

import UIKit
import Firebase
import FirebaseAuth

enum LoginStatus {
    case none                // 로그인전
    case validationFailed    // 입력실패
    case loginDenied         // 로그인거절
    case authenticated       // 인증완료
}

class LoginViewModel {
    
    // 유저가 입력한 글자 데이터
    private var emailString: String = ""
    private var passwordString: String = ""
    
    // 로그인 상태 데이터 ⭐️⭐️⭐️
    private var loginStatus: LoginStatus = .none
    
    //var loginStatusChanged: (LoginStatus) -> Void = { _ in }
    
    // Input
    func setEmailText(_ email: String) {
        emailString = email
    }
    
    func setPasswordText(_ password: String) {
        passwordString = password
    }
    

    // 실제 로그인 요청 메서드
        func loginUser(completion: @escaping (LoginStatus) -> Void) {
            guard !emailString.isEmpty && !passwordString.isEmpty else {
                self.loginStatus = .validationFailed
                completion(.validationFailed)
                return
            }

            // Firebase를 이용한 이메일/비밀번호 로그인 시도
            Auth.auth().signIn(withEmail: emailString, password: passwordString) { [unowned self] authResult, error in
                if let error = error {
                    self.loginStatus = .loginDenied
                    print("Error signing in: \(error.localizedDescription)")
                    completion(.loginDenied)
                    return
                }

                // 로그인 성공
                self.loginStatus = .authenticated
                print("Logged in successfully")
                
                completion(.authenticated)
            }
        }


    // 화면이동
    func goToNextScreen(from currentVC: UIViewController) {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        currentVC.present(tabBarController, animated: true)
    }
    
}

