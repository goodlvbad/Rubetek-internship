//
//  ImageLoader.swift
//  Rubetek-internship
//
//  Created by Светлана Кривобородова on 22.06.2022.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol: AnyObject {
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void)
}

final class ImageLoader {
    static let shared: ImageLoaderProtocol = ImageLoader()
}

extension ImageLoader: ImageLoaderProtocol {
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: urlString)
        guard let url = url else { return }
        
        guard let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        DispatchQueue.main.async {
            completion(image)
        }
    }
}
