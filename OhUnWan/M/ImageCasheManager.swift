//
//  ImageCasheManger.swift
//  OhUnWan
//
//  Created by 양홍찬 on 2023/08/16.
//
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}
    
    private var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 1024 * 1024 * 100 // 최대 100MB 캐시
        return cache
    }()
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
