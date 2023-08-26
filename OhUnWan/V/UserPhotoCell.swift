//
//  UserPhotoCell.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/02.
//

import UIKit
import SDWebImage

class UserPhotoCell: UITableViewCell {
    
    // MARK: - Properties
    
    // 작은 원형 유저 이미지를 표시하는 UIImageView
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20 // 원형 모양을 위해 코너를 둥글게 설정
        imageView.layer.masksToBounds = true // 이미지뷰 경계를 넘어가는 이미지는 잘라냄
        return imageView
    }()
    
    // 이름을 표시하는 UILabel
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16) // 굵은체 폰트로 설정
        return label
    }()
    
    // 큰 이미지를 표시하는 UIImageView
    let largeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
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
        contentView.addSubview(largeImageView) // 큰 이미지뷰 추가
        
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
            
            // 큰 이미지뷰 크기 제약 조건 추가
            largeImageView.widthAnchor.constraint(equalToConstant: 100),
            largeImageView.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    // MARK: - Configuration
    
    // 셀에 데이터를 설정하여 UI를 업데이트하는 메서드
    func configure(with profileImageURL: URL?, displayName: String, largeImageURL: URL?) {
        // 이미지를 초기화하여 새 데이터가 로딩될 때 이전 이미지가 남아있는 문제를 방지
        userImageView.image = nil
        nameLabel.text = displayName
        largeImageView.image = nil
        
        // 프로필 이미지 설정
        if let profileImageURL = profileImageURL {
            // 프로필 이미지를 비동기적으로 로딩하고 표시
            userImageView.loadImage(from: profileImageURL)
        }
        
        // 대표 이미지 설정
        if let largeImageURL = largeImageURL {
            // 대표 이미지를 비동기적으로 로딩하고 표시
            largeImageView.loadImage(from: largeImageURL)
        }
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
