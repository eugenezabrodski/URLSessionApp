//
//  ImageProperties.swift
//  URLSessionApp
//
//  Created by Eugene on 09/01/2024.
//

import UIKit

struct ImageProperties {
    
    let key: String
    let data: Data
    
    init?(forKey key: String, withImage image: UIImage) {
        self.key = key
        guard let data = image.pngData() else { return nil}
        self.data = data
    }
}
