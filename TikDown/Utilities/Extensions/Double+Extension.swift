//
//  Double+Extension.swift
//  TikDown
//
//  Created by Ali on 24.05.2022.
//

import Foundation
import UIKit

extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
