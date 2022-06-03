//
//  ScrollView+Extension.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

extension UIScrollView {
    //desc: update scroll frame
    func updateFrame(newOffsetPoint:CGFloat) {
        var scrollContentOffset = self.contentOffset
        scrollContentOffset.x = newOffsetPoint
        self.setContentOffset(scrollContentOffset, animated: true)
        self.contentOffset.y = 0
    }
}
