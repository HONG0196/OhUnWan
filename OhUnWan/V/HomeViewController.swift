import UIKit
import FirebaseAuth

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
        viewModel.fetchData { [weak self] error in
            if let error = error {
                print("Error fetching data:", error)
            } else {
                // 가져온 데이터를 사용하여 UI 업데이트 또는 처리
                self?.dataUpdated() // 데이터 업데이트 시 호출
            }
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 데이터를 업데이트하고 화면을 새로고침
        viewModel.fetchData { [weak self] error in
            if let error = error {
                print("Error fetching data:", error)
            } else {
                self?.dataUpdated()
            }
        }
    }
    
    // 데이터 업데이트 시 호출되는 메서드
    private func dataUpdated() {
        DispatchQueue.main.async {
            self.tableView.reloadData() // 테이블 뷰 업데이트
        }
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
    
    
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPhotoCell", for: indexPath) as! UserPhotoCell
        
        let post = viewModel.posts[indexPath.row]
        
        // 게시물에 대한 사용자 정보 가져오기
        if let user = viewModel.userForPost(at: indexPath.row),
           let profileImageURL = URL(string: user.profileImageURL),
           let largeImageURL = URL(string: post.imageURL) {
            cell.configure(
                with: profileImageURL,
                displayName: user.displayName,
                largeImageURL: largeImageURL,
                post: post // 여기에서 데이터를 전달
            )
        }
        
        // 좋아요 버튼의 동작 설정
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        // 좋아요 버튼을 눌렀을 때 수행할 동작을 여기에 추가
        // 예를 들어, 해당 셀의 인덱스를 가져와서 상태 변경 등의 로직을 구현
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = viewModel.posts[indexPath.row]
        
        let profileDetailVC = DetailViewController()
        
        // 프로필 이미지 설정
        if let user = viewModel.userForPost(at: indexPath.row),
           let profileImageURL = URL(string: user.profileImageURL) {
            APIService.shared.downloadImage(from: profileImageURL) { result in
                switch result {
                case .success(let profileImage):
                    DispatchQueue.main.async {
                        profileDetailVC.profileImage = profileImage
                    }
                case .failure(let error):
                    print("Error downloading profile image:", error)
                }
            }
        }
        
        // 이름 설정
        if let user = viewModel.userForPost(at: indexPath.row) {
            profileDetailVC.name = user.displayName
        }
        
        // 메인 이미지 설정
        if let mainImageURL = URL(string: selectedPost.imageURL) {
            profileDetailVC.mainImageURL = mainImageURL
        }
        
        // 설명 텍스트 설정
        profileDetailVC.descriptionText = selectedPost.text
        
        // postID 설정
        profileDetailVC.postID = selectedPost.postID
        
        // 현재 사용자의 UID 설정
        profileDetailVC.isCurrentUserPost = selectedPost.uid == Auth.auth().currentUser?.uid
        
        // 현재 사용자의 UID 설정
        profileDetailVC.uid = Auth.auth().currentUser?.uid
        
        // 탭바 가리기
        profileDetailVC.hidesBottomBarWhenPushed = true
        
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
            // DetailViewController를 생성하고 선택한 이미지와 관련된 정보를 설정
            let profileDetailVC = DetailViewController()
            profileDetailVC.mainImage = selectedImage
            profileDetailVC.descriptionText = "New Text View."
            
            // 사용자의 UID를 DetailViewController로 전달
            if let uid = Auth.auth().currentUser?.uid {
                profileDetailVC.uid = uid
            }
            
            // 탭바 가리기
            profileDetailVC.hidesBottomBarWhenPushed = true
            
            // DetailViewController로 이동
            navigationController?.pushViewController(profileDetailVC, animated: true)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
