//
//  PaywallViewModel.swift
//  TikDown
//
//  Created by Ali on 20.05.2022.
//

import Foundation
import RevenueCat
import StoreKit
import UIKit

class PaywallViewModel {
    //MARK: Properties
    //desc: shared instance
    public static var instance = PaywallViewModel()
    
    private let iconName = "checkedCircle"
    private let descriptions = [
        "Download unlimited HD videos",
        "Remove Ads",
        "Save music files of each video",
        "Repost on Insta, Snap",
        "Remove Watermark"
    ]
    
    private var productsModel: [SKProduct] = []
    
    //MARK: Functions
    func setDescriptions(
        stackView: UIStackView
    ) {
        for text in descriptions {
            let iconLabel = createLabelWithIcon(flag: iconName, aimTitle: text)
            stackView.addArrangedSubview(iconLabel)
        }
    }
    
    private func createLabelWithIcon(
        flag: String,
        aimTitle: String
    ) -> UILabel {
        let mainLabel = UILabel()
        // Create Attachment
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: flag)
        // Set bound to reposition
        let imageOffsetY: CGFloat = -4.0
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        // Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        completeText.append(attachmentString)
        // Add your text to mutable string
        let textAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)]
        let textAfterIcon1 = NSAttributedString(string: " ")
        let textAfterIcon = NSAttributedString(string: aimTitle, attributes: textAttributes as [NSAttributedString.Key : Any])
        completeText.append(textAfterIcon1)
        completeText.append(textAfterIcon)
        mainLabel.textAlignment = .left
        mainLabel.attributedText = completeText
        mainLabel.textColor = .white
        return mainLabel
    }
    
    //desc: paywall methods
    func fetchProducts(
        callback: (([SubscriptionModel]) -> Void)?
    ) {
        Purchases.shared.getOfferings { (offerings, error) in
            if let offerings = offerings {
                
                let offer = offerings.current
                let packages = offer?.availablePackages
                
                guard packages != nil else {
                    
                    return
                }
                var models: [SubscriptionModel] = []
                for i in 0...packages!.count - 1 {
                
                    //desc: get reference to the package
                    let package = packages![i]
                    
                    //desc: get reference to the product
                    let product = package.storeProduct
                    
                    //desc: product title
                    let title = product.localizedTitle
                    
                    //desc: product price
                    let price = product.price
                    
                    //desc: price string
                    let priceString = product.localizedPriceString
                    
                    //desc: let perByWeek
                    let perByWeekVal = (price as NSDecimalNumber).doubleValue
                    let perByWeek = perByWeekVal / 52
                    
                    //desc: product duration
                    var duration = ""
                    let subscriptionPeriod = product.subscriptionPeriod
                    
                    
                    switch subscriptionPeriod!.unit {
                    case SubscriptionPeriod.Unit.day:
                        duration = "1 Week"
                    case SubscriptionPeriod.Unit.year:
                        duration = "1 Year"
                    case SubscriptionPeriod.Unit.month:
                        duration = "1 Month"
                        //desc: unused
                        break
                    default:
                        break
                    }
                    
                    let model = SubscriptionModel(
                        idendifier: product.productIdentifier,
                        price: priceString,
                        product: package,
                        currencySymbol: String(product.localizedPriceString.first ?? Character("")),
                        perByWeek: String(format: "%.2f", perByWeek)
                    )
                    
                    print("product title = ", title)
                    print("product price = ", price, priceString, price.formatted())
                    print("product per by week = ", String(format: "%.2f", perByWeek))
                    print("product duration = \(duration)\n")
                    
                    models.append(model)

                    if i == packages!.count - 1 {
                        callback?(models)
                    }
                }
            }
        }
    }
    
    //MARK: Helper Functions
    
    //MARK: Actions
    func selectProduct(_ product: Package) {
        //desc: buy product
        Purchases.shared.purchase(
            package: product
        ) { (transaction, purchaserInfo, error, userCanceled) in
            
            if purchaserInfo?.entitlements.all["Subscriptions"]?.isActive == true {
                //desc: success subscriptions
                NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: nil)
            }
            
            if userCanceled {
                //desc: user canceled
                NotificationCenter.default.post(name: .IAPHelperPurchaseFailNotification, object: nil)
            }
        }
    }
    
    func restoreProdut() {
        //desc: restore product
        Purchases.shared.restorePurchases { purchaserInfo, error in
            print("result = ", purchaserInfo?.entitlements.all, error)
            if purchaserInfo?.entitlements.all["Subscriptions"]?.isActive == true {
                //desc: success subscriptions
                NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: nil)
            }
            
            if error != nil {
                //desc: user canceled
                NotificationCenter.default.post(name: .IAPHelperPurchaseFailNotification, object: nil)
            }
        }
    }
}

//MARK: Product Enums
enum Product: String, CaseIterable {
    case removeADS = "com.tikdown.removeAds"
    case unclockEverything = "com.tikdown.everything"
    case weekly = "com.tikdown.weekly_sub"
    case yearly = "com.tikdown.yearly_subs"
    case monthly = "com.tikdown.monthly"
}

