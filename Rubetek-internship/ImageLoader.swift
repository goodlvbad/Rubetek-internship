//
//  ImageLoader.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 22.06.2022.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol: AnyObject {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoader {
    
    private lazy var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 20 * 1000 * 1000
        return cache
    }()
    
    private lazy var loadingQueue = DispatchQueue(label: "image loading queue")
}

extension ImageLoader: ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        loadingQueue.async {
            if let image = self.cache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async {
                    completion(image)
                }
                return
            }
            
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.cache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
