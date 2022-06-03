//
//  Constants.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

class Constants {
    //desc: app fonts
    public class Fonts {
        public static var usable = Fonts()
        var sfproBlackItalic      = "SFPRODISPLAYBLACKITALIC"
        var sfproBold             = "SFPRODISPLAYBOLD"
        var sfproHeavyItalic      = "SFPRODISPLAYHEAVYITALIC"
        var sfproLightItalic      = "SFPRODISPLAYULTRALIGHTITALIC"
        var sfproMedium           = "SFPRODISPLAYMEDIUM"
        var sfproRegular          = "SFPRODISPLAYREGULAR"
        var sfproSemiboldItalic   = "SFPRODISPLAYSEMIBOLDITALIC"
        var sfproHinitItalic      = "SFPRODISPLAYTHINITALIC"
        var sfproUltraLightItalic = "SFPRODISPLAYULTRALIGHTITALIC"
    }

    //desc: vibrate generator
    public static let generator = UIImpactFeedbackGenerator(style: .light)
    
    //desc: common
    public static var hashtags: [Hashtag] = []
    public static var testAdmobID = "ca-app-pub-3940256099942544/2934735716"
    public static var admobBannerID = "ca-app-pub-5041485464666958/4313456357"
}

//MARK: Enums
enum SettingsTabs: String, CaseIterable {
    case shareApp = "Share Tik Down with friends"
    case contactUs = "Contact us"
    case restorePurchase = "Restore Purchase"
    case reviewUs = "Review us"
    case privacyPolicy = "Privacy Policy"
}

//MARK: Type Alias
typealias Hashtag = String
