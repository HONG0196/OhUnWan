//
//  SignUpViewController.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/04.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    let viewModel: SignUpViewModel
    
    // 코드로 구현할 때 뷰컨 생성자
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen // 여기서 modalPresentationStyle을 설정합니다.
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Properties

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "회원가입"
        return label
    }()

    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "이메일"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "비밀번호"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    }()

    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "비밀번호 확인"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    }()

    private let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("가입하기", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        
    }

    // MARK: - UI Setup

    private func setupViews() {
        // Delegate 설정 추가
           emailTextField.delegate = self
           passwordTextField.delegate = self
        
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signUpButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            signUpButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 32),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 150),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])

        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }

    // MARK: - Sign Up Action
    
    @objc private func handleSignUp() {
        guard let email = emailTextField.text, let password = passwordTextField.text, password == confirmPasswordTextField.text else {
            print("비밀번호가 일치하지 않습니다.")
            return
        }
        
        // 회원가입 시도
        viewModel.signUp(with: email, password: password) { [weak self] success in
            if success {
                // 회원가입 성공 시 처리
                print("Sign up success!")
                // 여기서 로그인 화면으로 돌아가거나, 필요한 동작을 수행할 수 있습니다.
                // 예를 들어, 로그인 화면으로 돌아가는 경우 아래와 같이 처리할 수 있습니다.
                self?.dismiss(animated: true, completion: nil)
            } else {
                // 회원가입 실패 시 처리
                print("Sign up failed!")
                // 여기서 회원가입 실패 시 사용자에게 알림을 보여주거나, 필요한 동작을 수행할 수 있습니다.
            }
        }
    }
    }

extension SignUpViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 키보드의 리턴 키를 눌렀을 때 다음 텍스트필드로 이동하도록 설정합니다.
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            textField.resignFirstResponder() // 회원가입 버튼 터치 시 유효성 검사를 수행하므로, 키보드를 닫습니다.
        default:
            break
        }
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // 비밀번호 필드와 비밀번호 확인 필드의 입력값이 일치하는지 확인합니다.
//        if textField == passwordTextField || textField == confirmPasswordTextField {
//            let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
//            let password = passwordTextField.text ?? ""
//            let confirmPassword = confirmPasswordTextField.text ?? ""
//            //signUpButton.isEnabled = !password.isEmpty && password == confirmPassword
//        }
//        return true
//    }
}
