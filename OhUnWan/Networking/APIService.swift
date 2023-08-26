//
//  Networking.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/02.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseDatabase

enum NetworkError: Error {
    case badRequest
    case decodingError
    case notAuthenticated
}

final class APIService {
    static let shared = APIService()
    private init() {}
    
    private let storageRef = Storage.storage().reference()
    private let databaseRef = Database.database().reference()
    
    // CREATE: 글 저장
    func createPost(image: UIImage, text: String, uid: String, completion: @escaping (Error?) -> Void) {
        // 이미지 업로드
        uploadImage(image) { [weak self] result in
            switch result {
            case .success(let imageURL):
                // 텍스트 데이터와 이미지 URL, UID를 Realtime Database에 저장
                self?.savePostToDatabase(text: text, imageURL: imageURL, uid: uid, completion: completion)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        // 이미지 데이터를 JPEG 형식으로 변환하고 리사이징
        guard let resizedImageData = image.resizedTo(maxWidth: 800)?.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "com.yourapp", code: -1, userInfo: nil)))
            return
        }
        
        let imageName = UUID().uuidString
        let imageRef = storageRef.child("images/\(imageName).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // 리사이징된 이미지를 Storage에 업로드
        imageRef.putData(resizedImageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                // 이미지 다운로드 URL을 가져옴
                imageRef.downloadURL { url, error in
                    if let url = url {
                        completion(.success(url))
                    } else {
                        completion(.failure(NSError(domain: "com.yourapp", code: -1, userInfo: nil)))
                    }
                }
            }
        }
    }
    
    private func savePostToDatabase(text: String, imageURL: URL, uid: String, completion: @escaping (Error?) -> Void) {
        let newPostRef = databaseRef.child("posts").childByAutoId()
        let post: [String: Any] = [
            "text": text,
            "imageURL": imageURL.absoluteString,
            "uid": uid,
            "timestamp": ServerValue.timestamp() // 현재 시간을 타임스탬프로 저장
        ]
        
        newPostRef.setValue(post) { error, _ in
            completion(error)
        }
    }
    
    // READ: Realtime Database에서 데이터 가져오는 메서드
    func fetchPosts(completion: @escaping ([Post], Error?) -> Void) {
        databaseRef.child("posts").observeSingleEvent(of: .value) { snapshot in
            var fetchedPosts: [Post] = []
            
            for childSnapshot in snapshot.children {
                if let childSnapshot = childSnapshot as? DataSnapshot,
                   let postDict = childSnapshot.value as? [String: Any],
                   let text = postDict["text"] as? String,
                   let imageURLString = postDict["imageURL"] as? String,
                   let uid = postDict["uid"] as? String,
                   let timestamp = postDict["timestamp"] as? TimeInterval {
                    
                    if let imageURL = URL(string: imageURLString) {
                        let post = Post(text: text, imageURL: imageURL, uid: uid, timestamp: timestamp)
                        fetchedPosts.append(post)
                    }
                }
            }
            
            completion(fetchedPosts, nil)
        }
    }
    
    // UPDATE: Realtime Database에서 데이터 수정하는 메서드
    func updatePost(postID: String, newText: String, completion: @escaping (Error?) -> Void) {
        let updatedData: [String: Any] = ["text": newText]
        databaseRef.child("posts").child(postID).updateChildValues(updatedData) { error, _ in
            completion(error)
        }
    }
    
    // DELETE: Realtime Database 및 Storage에서 데이터 삭제하는 메서드
    func deletePost(postID: String, imageURL: URL, completion: @escaping (Error?) -> Void) {
        // Storage에서 이미지 삭제
        storageRef.child("images").child(imageURL.lastPathComponent).delete { error in
            if let error = error {
                completion(error)
            } else {
                // Storage에서 삭제 성공한 경우, Realtime Database에서 데이터 삭제
                self.databaseRef.child("posts").child(postID).removeValue { error, _ in
                    completion(error)
                }
            }
        }
    }
}
// 리사이징
extension UIImage {
    func resizedTo(maxWidth: CGFloat) -> UIImage? {
        let scale = maxWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: maxWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: maxWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
// 이미지 다운로드를 처리
extension APIService {
    func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
}
