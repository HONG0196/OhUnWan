//
//  UserPhotoCell.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/02.
//

import UIKit

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
    func configure(with userImage: UIImage?, name: String, largeImage: UIImage?) {
        // 작은 유저 이미지 설정
        userImageView.image = userImage ?? UIImage(named: "image.png")
        nameLabel.text = name // 이름 설정
        // 큰 이미지 설정
                if let largeImage = largeImage {
                    largeImageView.image = largeImage
                    largeImageView.contentMode = .scaleAspectFill
                    largeImageView.clipsToBounds = true
                } else {
                    largeImageView.image = UIImage(named: "image.png")
                    largeImageView.contentMode = .scaleAspectFill
                    largeImageView.clipsToBounds = true
                }
    }
}

