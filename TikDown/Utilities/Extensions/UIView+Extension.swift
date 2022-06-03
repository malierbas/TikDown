//
//  UIButton+Extension.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

extension UIView {
    //desc: make rounded view
    func rounded() {
        let cornerVal = frame.height / 2
        layer.cornerRadius = cornerVal
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
    }
    
    //desc: make circle view
    func circle() {
        let circleVal = frame.width / 2
        layer.cornerRadius = circleVal
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0
    }
    
    //desc: add custom corner
    func setRadius(radii: CGFloat) {
        layer.cornerRadius = radii
    }
    
    //desc: setup border
    func setupBorder(
        size: CGFloat = 1,
        color: UIColor? = UIColor(named: "unUseed"),
        cornerRadius: CGFloat
    ) {
        layer.borderColor  = color?.cgColor
        layer.borderWidth  = size
        layer.cornerRadius = cornerRadius
    }
    
    func removeBorder() {
        layer.borderWidth = 0
    }
    
    //desc: fade
    func fadeIn(
        duration: CGFloat = 0.15,
        callback: (() -> Void)? = nil
    ) {
        UIView.animate(withDuration: TimeInterval(duration)) {
                   self.alpha = 1
               } completion: { isEnd in
                   if isEnd {
                       self.isHidden = false
                   }
                   callback?()
               }
    }
    
    func fadeOut(
        duration: CGFloat = 0.15,
        callback: (() -> Void)? = nil
    ) {
        UIView.animate(withDuration: TimeInterval(duration)) {
                    self.alpha = 0
                } completion: { isEnd in
                    if isEnd {
                        self.isHidden = true
                    }
                    
                    callback?()
                }
    }
    
    //: show form error
   func shake() {
       let animation = CABasicAnimation(keyPath: "position")
       animation.duration = 0.1
       animation.repeatCount = 3
       animation.autoreverses = true
       animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
       animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
       
       self.layer.add(animation, forKey: "position")
   }
}
