//
//  MyPageViewController.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/18.
//

import UIKit
import FirebaseAuth
import SDWebImage
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    var isEditingProfile = false
    
    // ViewModel 인스턴스 생성
    let profileViewModel = ProfileViewModel()
    
    // MARK: - UI 요소
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 20)
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
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
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(editButtonTapped))
        return button
    }()
    
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonTapped))
        return button
    }()
    
    
    
    // MARK: - 뷰 라이프사이클
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        loadUserData()
        navigationItem.rightBarButtonItem = editButton
        
        // 처음에는 텍스트 필드를 편집할 수 없도록 설정
        nameTextField.isEnabled = false
        
        // profileImageView를 탭하는 제스처 인식기
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - UI 설정
    
    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(nameTextField)
        view.addSubview(emailLabel)
        view.addSubview(logoutButton)
        
        profileImageView.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 30)
        ])
    }
    
    // MARK: - 사용자 정보 로드
    
    private func loadUserData() {
        // 사용자 정보 가져와서 UI 업데이트
        profileViewModel.fetchUser { [weak self] success in
            if success {
                // 사용자 정보 가져오기 성공한 경우에만 UI 업데이트
                DispatchQueue.main.async {
                    self?.updateUIWithUserData()
                }
            } else {
                print("사용자 정보 가져오기 실패")
            }
        }
    }
    
    // MARK: - Button

    @objc private func editButtonTapped() {
        // 편집 모드를 토글하여 현재 편집 상태를 관리합니다.
        isEditingProfile.toggle()
        
        if isEditingProfile {
            // 편집 가능한 상태로 전환하고 저장 버튼을 나타냅니다.
            nameTextField.isEnabled = true
            navigationItem.rightBarButtonItem = saveButton
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
            profileImageView.addGestureRecognizer(tapGestureRecognizer)
        } else {
            // 편집 가능한 상태를 해제하고 수정 버튼을 나타냅니다.
            nameTextField.isEnabled = false
            navigationItem.rightBarButtonItem = editButton
            profileImageView.gestureRecognizers?.forEach { recognizer in
                profileImageView.removeGestureRecognizer(recognizer)
            }
        }
    }

    
    @objc private func saveButtonTapped() {
        nameTextField.isEnabled = false
        isEditingProfile.toggle()
        // profileImageView의 기존 제스처 인식기를 제거합니다.
        profileImageView.gestureRecognizers?.forEach { recognizer in
            profileImageView.removeGestureRecognizer(recognizer)
        }
        
        let newName = nameTextField.text
        
        guard let newImage = profileImageView.image else {
            print("프로필 이미지가 없습니다.")
            return
        }
        
        // 프로필 업로드
        profileViewModel.uploadUserProfile(displayName: newName ?? "", profileImage: newImage) { [weak self] error in
            if let error = error {
                print("프로필 업로드 오류:", error)
            } else {
                print("프로필 업로드 완료")
            }
            self?.navigationItem.rightBarButtonItem = self?.editButton
        }
    }
    // 사용자 정보로 UI 업데이트
    private func updateUIWithUserData() {
        DispatchQueue.main.async { [weak self] in
            if let user = self?.profileViewModel.user {
                self?.nameTextField.text = user.displayName
                self?.emailLabel.text = user.email
                if let profileImageURL = URL(string: user.profileImageURL) {
                    self?.profileImageView.sd_setImage(with: profileImageURL, completed: nil)
                }
            } else {
                print("사용자 정보 없음")
            }
        }
    }
    
    
    // MARK: - 로그아웃 버튼 동작
    
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
            print("로그아웃 오류:", error.localizedDescription)
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @objc private func profileImageViewTapped() {
            if isEditingProfile {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated: true, completion: nil)
            }
        }
    
    // Image picker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
