//
//  DetailViewController.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/07.
//

import UIKit

class DetailViewController: UIViewController {
    
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
    
    // 데이터를 받아올 변수들을 선언
    var profileImage: UIImage?
    var name: String?
    var mainImage: UIImage?
    var descriptionText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    
    @objc private func saveButtonTapped() {
        //버튼을 눌렀을 때 수행할 동작을 여기에 추가
       
    }
}
