//
//  SubscriptionModel.swift
//  TikDown
//
//  Created by Ali on 23.05.2022.
//

import RevenueCat
import Foundation
import StoreKit
import UIKit

struct SubscriptionModel {
    var idendifier: String?
    var price: String?
    var product: Package?
    var currencySymbol: String?
    var perByWeek: String? = ""
}
