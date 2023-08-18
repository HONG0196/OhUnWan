//
//  MyPageViewController.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/18.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController {
    
    // MARK: - UI Elements
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50 // 프로필 사진을 원형으로 만들기 위한 코너 반지름 설정
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        loadUserData()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 30)
        ])
    }
    
    // MARK: - Load User Data
    
    private func loadUserData() {
        if let currentUser = Auth.auth().currentUser {
            nameLabel.text = currentUser.displayName
            emailLabel.text = currentUser.email
            if let profileImageURL = currentUser.photoURL {
                profileImageView.sd_setImage(with: profileImageURL)
            }
        }
    }
    
    // MARK: - Logout Button Action
    
    @objc private func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            
            // 로그아웃 후 모달로 표시된 ProfileViewController를 닫고 로그인 화면으로 이동
            self.dismiss(animated: true) {
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.showLoginScreen()
                }
            }
            
        } catch {
            print("로그아웃 에러:", error.localizedDescription)
        }
    }
}

