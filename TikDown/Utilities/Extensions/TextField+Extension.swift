//
//  TextField+Extension.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

extension UITextField {
    //desc: change placeholder text color
    func placeHolderColor(
        color: UIColor? = UIColor(named: "unUseed")
    ) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: color ?? UIColor.white]
        )
    }
}
