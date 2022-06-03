//
//  AppDelegate.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import UIKit
import RevenueCat
import GoogleMobileAds
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        window?.makeKeyAndVisible()
        AppUtils.setupFirebase()
        AppUtils.getHashtags()
        Purchases.configure(withAPIKey: "appl_HAugdRXJRjVAIljfaqXHIcZqDRU")
        Purchases.shared.delegate = self
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    } 
}

extension AppDelegate: PurchasesDelegate {
    
    func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        
        if customerInfo.entitlements.all["Subscriptions"]?.isActive == true {
            LocalStorageManager.shared.hasCredit = false
        } else {
            LocalStorageManager.shared.hasCredit = false
        }
    }
}
