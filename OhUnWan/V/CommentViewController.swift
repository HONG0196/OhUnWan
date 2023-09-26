//
//  CommentViewController.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/09/26.
//

import UIKit

class CommentViewController: UIViewController {
    
    // MARK: - Properties
    
    //var viewModel = CommentViewModel()
    
    // MARK: - UI Elements
    
    // 댓글을 표시할 테이블 뷰
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // 댓글 작성을 위한 텍스트 필드
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글 작성..."
        textField.backgroundColor = .white // 배경색을 흰색으로 설정
        textField.layer.cornerRadius = 8 // 테두리를 둥글게 처리
        textField.layer.borderWidth = 1.0 // 테두리 선 두께
        textField.layer.borderColor = UIColor.gray.cgColor // 테두리 선 색상
        return textField
    }()
    
    // 댓글 작성 버튼
    private let postCommentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글 작성", for: .normal)
        button.backgroundColor = .white // 배경색을 흰색으로 설정
        button.layer.cornerRadius = 8 // 테두리를 둥글게 처리
        button.layer.borderWidth = 1.0 // 테두리 선 두께
        button.layer.borderColor = UIColor.gray.cgColor // 테두리 선 색상
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "댓글"
        
        view.backgroundColor = .white // 뷰의 배경색을 흰색으로 설정
        
        view.addSubview(tableView)
        view.addSubview(commentTextField)
        view.addSubview(postCommentButton)
        
        setupConstraints()
        
        postCommentButton.addTarget(self, action: #selector(postCommentButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - UI Constraints
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        commentTextField.translatesAutoresizingMaskIntoConstraints = false
        postCommentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // tableView 제약 조건 설정
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentTextField.topAnchor, constant: -16),
            
            // commentTextField 제약 조건 설정
            commentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentTextField.bottomAnchor.constraint(equalTo: postCommentButton.topAnchor, constant: -16),
            
            // postCommentButton 제약 조건 설정
            postCommentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            postCommentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            postCommentButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            postCommentButton.heightAnchor.constraint(equalToConstant: 40) // 버튼 높이 설정
        ])
    }
    
    // MARK: - Button Actions
    
    // 댓글 작성버튼 액션
    @objc private func postCommentButtonTapped() {

    }
}
