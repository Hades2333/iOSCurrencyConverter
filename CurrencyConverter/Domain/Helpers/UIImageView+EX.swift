//
//  UIImageView+EX.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 03/02/2025.
//

import UIKit

extension UIImageView {
    
    private static var imageCache = NSCache<NSString, UIImage>()

    func setFlagImage(by code: String) async {
        if code.lowercased() == "eu" {
            updateImage(UIImage(named: "EU_flag"))
            return
        }
        
        let urlString = "https://flagsapi.com/\(code)/flat/64.png"
        
        if let cachedImage = UIImageView.imageCache.object(forKey: urlString as NSString) {
            updateImage(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            updateImage(nil)
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                updateImage(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                updateImage(nil)
                return
            }
            
            UIImageView.imageCache.setObject(image, forKey: urlString as NSString)
            
            updateImage(image)
            
        } catch {
            updateImage(nil)
        }
    }
    
    @MainActor
    private func updateImage(_ image: UIImage?) {
        self.image = image
    }
}
