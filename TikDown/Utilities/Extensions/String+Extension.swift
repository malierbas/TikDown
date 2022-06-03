//
//  String+Extension.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

extension String {
    //desc: for draw any text
    func drawText(
        textToDraw: [String],
        color: UIColor? = UIColor(named: "AccentColor"),
        font: UIFont
    ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        let normalRange = (self as NSString).range(of: self)
        for string in textToDraw {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color!, range: range)
        }
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: normalRange)
        return attributedString
    }
    
    func before(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let before = prefix(upTo: index)
            return String(before)
        }
        return ""
    }
    
    func after(first delimiter: Character) -> String {
        if let index = firstIndex(of: delimiter) {
            let after = suffix(from: index).dropFirst()
            return String(after)
        }
        return ""
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
