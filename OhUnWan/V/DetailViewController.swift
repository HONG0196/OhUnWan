//
//  DetailViewController.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/07.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let viewModel = DetailViewModel()
    
    var isCurrentUserPost: Bool = false // 현재 사용자가 게시물의 작성자인지 여부를 나타내는 프로퍼티
    
    
    // 데이터를 받아올 변수들을 선언
    var profileImage: UIImage?
    var name: String?
    var mainImage: UIImage?
    var descriptionText: String?
    var mainImageURL: URL?
    var uid: String?
    var postID: String?
    
    
    // UI 요소들을 선언
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .black
        textView.isEditable = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1.0
        return textView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Check if the current user is the author of the post
        if isCurrentUserPost {
            saveButton.setTitle("Update", for: .normal)
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteButtonTapped))
        } else {
            saveButton.setTitle("Save", for: .normal)
        }
        
    }
    
    // UI를 설정
    private func setupUI() {
        view.backgroundColor = .white
        
        // 스크롤 뷰와 컨텐츠 뷰를 추가
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 컨텐츠 뷰에 UI 요소들을 추가
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(mainImageView)
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(saveButton)
        contentView.addSubview(commentButton)
        
        // 제약 조건
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 컨텐츠 뷰의 높이
            contentView.heightAnchor.constraint(equalToConstant: 1000),
            
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            
            mainImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.widthAnchor.constraint(equalToConstant: 300),
            mainImageView.heightAnchor.constraint(equalToConstant: 300),
            
            descriptionTextView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // 댓글 버튼 위치 설정
            commentButton.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor), // 높이 중앙 정렬
            commentButton.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50), // saveButton의 왼쪽에 배치
            
            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        
        // Set values
        profileImageView.image = profileImage
        nameLabel.text = name
        mainImageView.image = mainImage
        descriptionTextView.text = descriptionText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // mainImageURL이 있다면 이미지를 로드하여 mainImageView에 표시
        if let imageURL = mainImageURL {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.mainImageView.image = image
                    }
                }
            }
        }
    }
    
    @objc private func saveButtonTapped() {
        guard let uid = uid else {
            print("UID is missing.")
            return
        }
        
        // 게시물 생성에 필요한 데이터 설정
        let postImage = mainImage ?? UIImage()
        let postText = descriptionTextView.text ?? ""
        
        if isCurrentUserPost {
            // 업데이트 기능
            guard let postID = postID else {
                print("Post ID is missing.")
                return
            }
            
            viewModel.updatePost(postID: postID, newText: postText) { [weak self] (error: Error?) in
                if let error = error {
                    // 에러 처리
                    print("Error updating post:", error)
                } else {
                    // 게시물 업데이트 성공한 경우 처리
                    print("Post updated successfully!")
                    
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            // 생성 기능
            viewModel.createPost(image: postImage, text: postText, uid: uid) { [weak self] (error: Error?) in
                if let error = error {
                    // 에러 처리
                    print("Error creating post:", error)
                } else {
                    // 게시물 생성 성공한 경우 처리
                    print("Post created successfully!")
                    
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @objc private func deleteButtonTapped() {
        guard let postID = postID, let mainImageURL = mainImageURL else {
            print("Post ID or mainImageURL is missing.")
            return
        }

        viewModel.deletePost(postID: postID, imageURL: mainImageURL) { [weak self] (error: Error?) in
            if let error = error {
                // 에러 처리
                print("Error deleting post:", error)
            } else {
                // 게시물 삭제 성공한 경우 처리
                print("Post deleted successfully!")

                // 게시물이 삭제되었으므로 이전 화면으로 돌아감
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc private func commentButtonTapped() {
        // 댓글 창을 모달로 표시
        let commentViewController = CommentViewController() // 댓글 창을 나타내는 뷰 컨트롤러를 만듭니다.
        present(commentViewController, animated: true, completion: nil) // 모달로 표시
    }
}
