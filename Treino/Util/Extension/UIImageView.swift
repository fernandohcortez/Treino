//
//  UIImageView.swift
//  Treino
//
//  Created by Fernando Cortez on 17/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(withImageUrlString: String?) {
        
        self.image = nil
        
        if let imageUrlString = withImageUrlString {
            
            if let url = URL(string: imageUrlString) {
                
                if let cachedImage = imageCache.object(forKey: imageUrlString as AnyObject) as? UIImage {
                    
                    self.image = cachedImage
                    return
                }
                
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        
                        if let downloadedImage = UIImage(data: data!) {
                            
                            imageCache.setObject(downloadedImage, forKey: imageUrlString as AnyObject)
                            
                            self.image = downloadedImage
                        }
                    }
                }).resume()
            }
        }
    }
}
