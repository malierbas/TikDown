//
//  LocalStorageManager.swift
//  TikDown
//
//  Created by Ali on 19.05.2022.
//

import Foundation
import UIKit

enum StorageNames: String {
    case awemeVideos = "awemeVideos"
    case otherVideos = "otherVideos"
    case awemeMusics = "awemeMusics"
    case otherMusics = "otherMusics"
    case claimCredit = "isCreditClaim"
    case hasCredit   = "hasCredit"
    case isReviewShowed = "isReviewShowed"
}

class LocalStorageManager {
    //MARK: Properties
    public static var shared = LocalStorageManager()
    private var defaults = UserDefaults.standard
    
    //MARK: Savable variables
    var awemeVideos: [DownloadAwemeModel]? {
        get {
            
            return try? defaults.getObject(forKey: StorageNames.awemeVideos.rawValue, castTo: [DownloadAwemeModel].self)
        }
        set {
            do {
                try defaults.setObject(newValue, forKey: StorageNames.awemeVideos.rawValue)
            } catch {
                print("an save error occured = ", error.localizedDescription)
            }
        }
    }
    
    var otherVideos: [DownloadOtherModel]? {
        get {
            
            return try? defaults.getObject(forKey: StorageNames.otherVideos.rawValue, castTo: [DownloadOtherModel].self)
        }
        set {
            do {
                try defaults.setObject(newValue, forKey: StorageNames.otherVideos.rawValue)
            } catch {
                print("an save error occured = ", error.localizedDescription)
            }
        }
    }
    
    var awemeMusics: [DownloadAwemeModel]? {
        get {
            
            return try? defaults.getObject(forKey: StorageNames.awemeMusics.rawValue, castTo: [DownloadAwemeModel].self)
        }
        set {
            do {
                try defaults.setObject(newValue, forKey: StorageNames.awemeMusics.rawValue)
            } catch {
                print("an save error occured = ", error.localizedDescription)
            }
        }
    }
    
    var otherMusics: [DownloadOtherModel]? {
        get {
            
            return try? defaults.getObject(forKey: StorageNames.otherMusics.rawValue, castTo: [DownloadOtherModel].self)
        }
        set {
            do {
                try defaults.setObject(newValue, forKey: StorageNames.otherMusics.rawValue)
            } catch {
                print("an save error occured = ", error.localizedDescription)
            }
        }
    }
    
    
    //MARK: Paywall
    var hasCredit: Bool! {
        get {
            return defaults.bool(forKey: StorageNames.hasCredit.rawValue)
        }
        set {
            defaults.set(newValue, forKey: StorageNames.hasCredit.rawValue)
        }
    }
    
    var isAllCreditClaim: Bool! {
        get {
            return defaults.bool(forKey: StorageNames.claimCredit.rawValue)
        }
        set {
            defaults.set(newValue, forKey: StorageNames.claimCredit.rawValue)
        }
    }
    
    var isReviewViewShowed: Bool! {
        get {
            
            return defaults.bool(forKey: StorageNames.isReviewShowed.rawValue)
        }
        set {
            defaults.set(newValue, forKey: StorageNames.isReviewShowed.rawValue)
        }
    }
    
    //MARK: remove data
    func removeDatas(forKeys: [StorageNames]) {
        for key in forKeys {
            defaults.removeObject(forKey: key.rawValue)
        }
    }
}
