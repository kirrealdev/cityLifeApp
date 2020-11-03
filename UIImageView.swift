//
//  UIImageView.swift
//  CityLife
//
//  Created by KirRealDev on 28.10.2020.
//  Copyright © 2020 KirRealDev. All rights reserved.
//

import Foundation
import UIKit

//extension UIImageView {
//    
//    func loadImage(by imageURL: String) {
//        let url = URL(string: imageURL)!
//
//        let cache = URLCache.shared
//        let request = URLRequest(url: url)
//
//        if let imageData = cache.cachedResponse(for: request)?.data {
//            self.image = UIImage(data: imageData)
//        } else {
//            URLSession.shared.dataTask(with: request) { (data, response, _) in
//                DispatchQueue.main.async {
//                    guard let data = data, let response = response else {
//                        return
//                    }
//                    let cacheRepsonse = CachedURLResponse(response: response, data: data)
//                    cache.storeCachedResponse(cacheRepsonse, for: request)
//                    self.image = UIImage(data: data)
//                }
//                
//            }.resume()
//        }
//    }
//}


// How to convert a hex color to a UIColor

extension UIColor {

    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }

}
