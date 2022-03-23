//
//  UIImageView.swift
//  WalE
//
//  Created by Bappaditya Dey on 23/03/22.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(withUrl urlString : String) async {
        let url = URL(string: urlString)
        guard let url = url else { return }
        self.image = nil
        
        // Return the cached image if available
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = CGPoint(x:self.frame.width/2,
                                           y: self.frame.height/2)
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
            self.addSubview(activityIndicator)
        }
        //Download image from Url
        let request = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            switch response.statusCode {
            case 200...299:
                if let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            case 401:
                return
            default:
                return
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

