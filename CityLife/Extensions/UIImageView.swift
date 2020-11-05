//
//  UIImageView.swift
//  CityLife
//
//  Created by KirRealDev 
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImageByURL(by imageURL: String) { // rename
        let url = URL(string: imageURL)!

        let cache = URLCache.shared
        let request = URLRequest(url: url)

        if let imageData = cache.cachedResponse(for: request)?.data {
            self.image = UIImage(data: imageData)
        } else {
            URLSession.shared.dataTask(with: request) { (data, response, _) in
                DispatchQueue.main.async {
                    guard let data = data, let response = response else {
                        return
                    }
                    let cacheRepsonse = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cacheRepsonse, for: request)
                    self.image = UIImage(data: data)
                }
                
            }.resume()
        }
    }
}

