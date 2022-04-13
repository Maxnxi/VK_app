//
//  UIImageViewExtension.swift
//  Homework_1
//
//  Created by Maksim on 12.03.2021.
//

import Foundation
import UIKit

extension UIImageView {
    
    func makeRounded(cornerRadius: CGFloat, borderWidth: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    func loadImage(imageUrlString: String) {
        guard let url = URL(string: imageUrlString) else { return }
        
        let cache = URLCache.shared
        let request = URLRequest(url: url)
        
        if let imageData = cache.cachedResponse(for: request)?.data {
            self.image = UIImage(data: imageData)
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] (data,response, error) in
                guard let data = data, let response = response else {
                    print("error", error?.localizedDescription ?? "not localizedDescription")
                    return
                }
                let cacheResponse = CachedURLResponse(response: response, data: data)
                cache.storeCachedResponse(cacheResponse, for: request)
                DispatchQueue.main.async {
                    self?.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
