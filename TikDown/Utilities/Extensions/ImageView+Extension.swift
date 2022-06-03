//
//  ImageView+Extension.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Kingfisher
import UIKit

extension UIImageView {
    //desc: load new image
    func load(imageUrl: String?) {
        guard let imageUrlString = imageUrl, let imageURL = URL(string: imageUrlString)  else {
            print("image not find")
            return
        }

        kf.indicatorType = .activity
        kf.setImage(with: imageURL)
    }
    
    //desc: set new image
    func set(_ named: String, _ system: Bool) {
        guard !system else {
            UIView.animate(withDuration: 0.15, delay: 0) {
                self.image = UIImage.init(systemName: named)
            }
            return
        }
        
        UIView.animate(withDuration: 0.15, delay: 0) {
            self.image = UIImage(named: named)
        }
    }
}
