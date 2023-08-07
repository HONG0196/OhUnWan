//
//  HomeViewController.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/02.
//

import UIKit

class HomeViewController: UIViewController {

    private let tableView = UITableView()
    private var data: [String] = [] // 데이터 배열

    let viewModel: HomeViewModel

    // 코드로 구현할 때 뷰컨 생성자 ⭐️⭐️⭐️
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
        loadData() // 데이터를 로드하는 메서드 호출
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

    // 뷰모델에서 데이터 가져다가 표시 ⭐️⭐️⭐️
    private func configureUI() {
        //self.basicLabel.text = viewModel.userEmailString
    }

    // MARK: - 오토레이아웃

    private func setupAutoLayout() {


    }

    // MARK: - 데이터 처리

    private func loadData() {
        // 데이터를 가져오는 로직 (예시로 고정된 데이터 사용)
        data = ["1", "2", "3", "4", "5"]
        tableView.reloadData() // 테이블 뷰 데이터 리로드
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        //viewModel.userList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPhotoCell", for: indexPath) as! UserPhotoCell
        
        // 데이터를 가져와서 셀에 설정
        let name = data[indexPath.row] // 이름
        cell.configure(with: UIImage(named: "image.png"), name: name, largeImage: UIImage(named: "image.png"))
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedName = data[indexPath.row]
            let selectedImage = UIImage(named: "image.png")
            
            let profileDetailVC = DetailViewController()
            profileDetailVC.profileImage = selectedImage
            profileDetailVC.name = selectedName
            profileDetailVC.descriptionText = "Text View."
            
            navigationController?.pushViewController(profileDetailVC, animated: true)
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
