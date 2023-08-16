//
//  HomeViewController.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/02.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let tableView = UITableView()
    
    // viewModel 생성
    let viewModel: HomeViewModel
    
    // 뷰컨 생성자
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        // Firebase에서 데이터를 가져와 표시
        viewModel.fetchPosts { [weak self] in
            self?.tableView.reloadData()
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: - BarButton
    
    @objc private func addButtonTapped() {
        // 바 버튼을 눌렀을 때 수행할 동작을 여기에 추가
        // 이미지 선택을 위한 이미지 피커 뷰 컨트롤러 생성
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        // 이미지 선택 후에는 DetailViewController로 이동
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - UI
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UserPhotoCell.self, forCellReuseIdentifier: "UserPhotoCell") // Correct cell registration
        tableView.dataSource = self // Set the data source delegate
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    // 뷰모델에서 데이터 가져다가 표시 
    private func configureUI() {
        //self.basicLabel.text = viewModel.userEmailString
    }
    
    // MARK: - 오토레이아웃
    
    private func setupAutoLayout() {
        
    }
    
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPhotoCell", for: indexPath) as! UserPhotoCell
        
        let post = viewModel.posts[indexPath.row]
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: post.imageURL),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.configure(with: nil, name: post.text, mainImageURL: post.imageURL, largeImageURL: nil, descriptionText: "")
                    cell.largeImageView.image = image // 이미지 설정
                    cell.userImageView.image = image
                }
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = viewModel.posts[indexPath.row]
        
        let profileDetailVC = DetailViewController()
        profileDetailVC.profileImage = UIImage(named: "image.png") // 프로필 이미지 설정
        profileDetailVC.name = "UserName"
        profileDetailVC.mainImageURL = selectedPost.imageURL // 이미지 URL 설정
        profileDetailVC.descriptionText = selectedPost.text
        
        navigationController?.pushViewController(profileDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // 이미지 선택이 완료된 경우 호출되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            let profileDetailVC = DetailViewController()
            profileDetailVC.mainImage = selectedImage
            profileDetailVC.descriptionText = "New Text View."
            
            navigationController?.pushViewController(profileDetailVC, animated: true)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 이미지 선택이 취소된 경우 호출되는 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
