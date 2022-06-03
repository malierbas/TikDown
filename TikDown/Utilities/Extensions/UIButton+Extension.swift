//
//  UIButton+Extension.swift
//  TikDown
//
//  Created by Ali on 20.05.2022.
//

import Foundation
import UIKit

extension UIButton {
    
    func increaseArea(size: CGFloat) {
        contentEdgeInsets = UIEdgeInsets(top: -size, left: -size, bottom: -size, right: -size)
    }
}
