//
//  UserPhotoCell.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/02.
//

import UIKit
import SDWebImage
import FirebaseAuth

class UserPhotoCell: UITableViewCell {
    
    // MARK: - Properties
    var post: Post?
    let heartImage = UIImage(named: "heart.png") // 이미지 이름에 맞게 수정
    let heartImageSize = CGSize(width: 40, height: 40) // 원하는 크기로 수정
    
    var resizedHeartImage: UIImage? // 리사이즈된 이미지 변수
    
    var likeButtonTappedHandler: (() -> Void)?
    
    // 작은 원형 유저 이미지를 표시하는 UIImageView
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // 이름을 표시하는 UILabel
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    // 큰 이미지를 표시하는 UIImageView
    let largeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 하트 버튼을 표시하는 UIButton
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        resizedHeartImage = heartImage?.resized(to: heartImageSize)
        likeButton.setImage(resizedHeartImage, for: .normal) // 이미지 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageView.image = nil
        nameLabel.text = ""
        largeImageView.image = nil
    }
    
    // MARK: - UI Setup
    
    private func setupViews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(largeImageView)
        contentView.addSubview(likeButton)
        
        // Constraints 설정
        NSLayoutConstraint.activate([
            // User Image View
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            userImageView.widthAnchor.constraint(equalToConstant: 40),
            userImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Name Label
            nameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            
            // Large Image View
            largeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            largeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            largeImageView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 16),
            largeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            // 큰 이미지뷰 크기 제약 조건 추가
            largeImageView.widthAnchor.constraint(equalToConstant: 100),
            largeImageView.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    // likeButtonTapped
    @objc private func likeButtonTapped() {
        print("likeButtonTapped called")
        
        // 현재 사용자의 UID를 가져오기
        guard let currentUserUID = AuthService.shared.getCurrentUserUID() else {
            // 사용자 UID를 가져올 수 없는 경우, 처리를 중단
            print("Current user UID not found")
            return
        }
        
        if var post = self.post {
            // 클라이언트 측의 토글 작업
            post.likes.toggleLike(forPost: post, currentUserUID: currentUserUID) // 좋아요 토글
            
            // 서버에 좋아요 상태 업데이트 요청
            APIService.shared.updateLikeStatus(for: post.postID, currentUserUID: currentUserUID) { [weak self] error in
                if let error = error {
                    print("Error updating like status:", error)
                } else {
                    // 업데이트된 post를 다시 할당
                    self?.post = post
                    
                    // UI 업데이트 코드 (클라이언트 측)
                    DispatchQueue.main.async {
                        if post.likes.usersLiked.contains(currentUserUID) {
                            self?.likeButton.setImage(UIImage(named: "fillheart.png"), for: .normal)
                            print("Updated like status: Liked")
                        } else {
                            self?.likeButton.setImage(self?.resizedHeartImage, for: .normal)
                            print("Updated like status: Not liked")
                        }
                        self?.likeButtonTappedHandler?() // 클로저를 호출하여 셀 리로딩 요청
                    }
                }
            }
        }
    }




    
    // MARK: - Configuration
    
    // 셀에 데이터를 설정하여 UI를 업데이트하는 메서드
    func configure(with profileImageURL: URL?, displayName: String, largeImageURL: URL?, post: Post) {
        // 이름 설정
        nameLabel.text = displayName

        // 게시물의 좋아요 상태에 따라 하트 이미지 업데이트
        if let currentUserUID = AuthService.shared.getCurrentUserUID() {
            if post.likes.usersLiked.contains(currentUserUID) {
                self.likeButton.setImage(UIImage(named: "fillheart.png"), for: .normal)
            } else {
                self.likeButton.setImage(self.resizedHeartImage, for: .normal)
            }
        } else {
            // 현재 사용자 UID를 가져올 수 없는 경우, 좋아요 버튼을 초기화 상태로 설정
            self.likeButton.setImage(self.resizedHeartImage, for: .normal)
        }

        // 프로필 이미지 설정
        if let profileImageURL = profileImageURL {
            // 프로필 이미지를 비동기적으로 로딩하고 표시
            userImageView.loadImage(from: profileImageURL)
        }

        // 대표 이미지 설정
        if let largeImageURL = largeImageURL {
            // 대표 이미지를 비동기적으로 로딩하고 표시
            largeImageView.loadImage(from: largeImageURL)
        } else {
            // 대표 이미지 URL이 없는 경우, 이미지 뷰 초기화
            largeImageView.image = nil
        }

        // 셀에 대한 데이터 설정
        self.post = post
    }
}
extension UIImageView {
    func loadImage(from url: URL) {
        // 이미지를 캐시에서 불러옴
        if let cachedImage = SDImageCache.shared.imageFromDiskCache(forKey: url.absoluteString) {
            // 캐시에서 이미지를 불러와서 표시
            self.image = cachedImage
            return
        }
        
        // SDWebImage를 사용하여 이미지를 비동기적으로 로딩하고 캐싱
        self.sd_setImage(with: url, placeholderImage: nil, options: [.continueInBackground, .progressiveLoad]) { [weak self] (image, _, _, _) in
            guard let self = self, let image = image else {
                return
            }
            // 이미지 캐시에 저장
            SDImageCache.shared.store(image, forKey: url.absoluteString, toDisk: true, completion: nil)
        }
    }
}
extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
