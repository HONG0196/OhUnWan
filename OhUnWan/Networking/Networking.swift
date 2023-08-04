//
//  Networking.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/02.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError
    case notAuthenticated
}

final class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    // 테스트 형태 ⭐️⭐️⭐️
    func loginTest(username: String, password: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        
        if username == "1@gmail.com" && password == "1" {
            completion(.success(()))
            return
        } else {
            completion(.failure(.notAuthenticated))
            return
        }
    }
    
    func signUpTest(username: String, password: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        // 실제 서버와의 통신이 아니라 테스트 메서드이므로, 더미 데이터를 이용하여 회원가입 성공/실패를 판단합니다.
        // 더미 데이터: 유효한 이메일과 비밀번호를 입력하면 회원가입 성공, 그 외의 경우에는 실패로 간주합니다.
        let validEmail = "test@gmail.com"
        let validPassword = "1234"
        
        if username == validEmail && password == validPassword {
            completion(.success(())) // 회원가입 성공
        } else {
            completion(.failure(.notAuthenticated)) // 회원가입 실패
        }
    }
    
    // 실제 API형태 ⭐️⭐️⭐️
    func login(username: String, password: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        
        let url = URL(string: "...")!
        
        let loginData = ["username": username, "password": password]
        
        // 리퀘스트 생성 (포스트)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(loginData)
        
        // with 리퀘스트 ===> URLSession
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                      completion(.failure(.badRequest))
                      return
                  }
            
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            if loginResponse.success {
                completion(.success(()))
                return
            } else {
                completion(.failure(.notAuthenticated))
                return
            }
        }.resume()
    }
    
    func signUp(username: String, password: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        // 실제 서버와의 통신 로직을 구현해야 합니다.
        // 서버로부터 받은 결과를 completion 핸들러를 통해 전달합니다.
    }
}
