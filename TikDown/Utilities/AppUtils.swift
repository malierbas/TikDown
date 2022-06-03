//
//  AppUtils.swift
//  TikDown
//
//  Created by Ali on 19.05.2022.
//

import SwiftConfettiView
import StoreKit
import FirebaseCore
import MBProgressHUD
import AVFoundation
import Foundation
import Photos
import AVKit
import UIKit
import RevenueCat

enum AppStoreReviewManager {
  static func requestReviewIfAppropriate() {
        SKStoreReviewController.requestReview()
  }
}

class AppUtils {
    //MARK: Properties
    private var confettiView: SwiftConfettiView!
    public static var instance = AppUtils()
    //MARK: Functions
    static func showSuccessAlert(
        on vc: UIViewController,
        _ isVideo: Bool,
        _ isDelete: Bool
    ) {
        let alert = UIAlertController(title: "Success", message: "Your \(isVideo ? "video" : "music") successfully \(isDelete ? "deleted!" : "saved!")", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
    static func showAlert(
        on vc: UIViewController,
        _ title: String,
        _ message: String,
        callback: (() -> Void)?
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        vc.present(alert, animated: true, completion: callback)
    }
    
    static func showPaywall(
        on vc: UIViewController,
        callback: (() -> Void)?
    ) {
        let paywallVC = vc.storyboard?.instantiateViewController(withIdentifier: "PaywallViewController") as! PaywallViewController
        paywallVC.modalPresentationStyle = .fullScreen
        vc.present(paywallVC, animated: true, completion: callback)
    }
    
    static func showPlayerView(
        playURL: URL,
        _ vc: UIViewController
    ) {
        DispatchQueue.main.async {
            let player = AVPlayer(url: playURL)
            let playerVC = AVPlayerViewController()
            playerVC.player = player
            
            vc.present(playerVC, animated: true) {
                
                playerVC.player?.play()
            }
        }
    }
    
    static func setupFirebase() {
        FirebaseApp.configure()
    }
    
    //MARK: Actions
    
    //MARK: Helper Functions
    static func showIndicator(on view: UIViewController, animated: Bool = true) {
        MBProgressHUD.showAdded(to: view.view, animated: animated)
    }
    
    static func hideIndicator(on view: UIViewController, animated: Bool = true) {
        MBProgressHUD.hide(for: view.view, animated: animated)
    }
    
    static func getHashtags() {
        
        let networking = NetworkManager.shared
        networking.getHashtags { data in
            Constants.hashtags = data
        }
    }
    
    static func showReviewView() {
        AppStoreReviewManager.requestReviewIfAppropriate()
    }
    
    static func checkSubscriptions() {
        
        Purchases.shared.getCustomerInfo { info, error in
            if info?.entitlements.all["Subscriptions"]?.isActive == true {
                LocalStorageManager.shared.hasCredit = true
            } else {
                LocalStorageManager.shared.hasCredit = false
            }
        }
    }
    
    //desc: get downloaded url
    static func getDownloadedMusic(
        fileName: String?,
        callback: ((_ fileName: String?) -> ())? = nil
    ) {
        if let fileName = fileName {
            guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
                return
            }
            
            let filePath = "\(documentsPath)/\(fileName).mp3"
            
            callback?(filePath)
        } else {
            print("file name not exist!!")
            callback?(nil)
        }
    }
    
    static func getDownloadedImage(
        fileName: String?,
        callback: ((_ fileName: String?) -> ())? = nil
    ) {
        if let fileName = fileName {
            guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
                return
            }
            
            let filePath = "\(documentsPath)/\(fileName).mp4"
            
            callback?(filePath)
        } else {
            print("file name not exist!!")
            callback?(nil)
        }
    }
    
    
    //desc: format play count
    static func formatPlayCount(num: Double) ->String {
        var thousandNum = num/1000
        var millionNum = num/1000000

        if num >= 1000 && num < 1000000{
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))K").replacingOccurrences(of: ".0", with: "")
            }
            return("\(thousandNum.roundToPlaces(places: 1))K").replacingOccurrences(of: ".0", with: "")
        }

        if num >= 1000000{
            //if(floor(millionNum) == millionNum){
                //return("\(Int(thousandNum))K").replacingOccurrences(of: ".0", with: "")
            //}
            return ("\(millionNum.roundToPlaces(places: 1))M").replacingOccurrences(of: ".0", with: "")
        }else {
            if(floor(num) == num){
                return ("\(Int(num))")
            }
            return ("\(num)")
        }
    }
    
    //MARK: Share
    static func shareWithOtherApps(
        filePath: String,
        vc: UIViewController
    ) {
        let activityVC = UIActivityViewController(activityItems: [NSURL(fileURLWithPath: filePath)], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.addToReadingList, .assignToContact]
        vc.present(activityVC, animated: true, completion: nil)
    }
    
    //MARK: Save
    static func saveToLibrary(
        filePath: String,
        vc: UIViewController,
        callback: ((_ completed: Bool) -> Void)? = nil
    ) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
        }) { completed, error in
            DispatchQueue.main.async {
                callback?(completed)
            }
        }
    }
    
    //MARK: Animation
    static func showConfetti(
        _ vc: UIViewController,
        _ confettiType: SwiftConfettiView.ConfettiType,
        _ confettiColors: [UIColor],
        _ intensity: Float
    ) {
        let confettiView = SwiftConfettiView(frame: vc.view.bounds)
        vc.view.addSubview(confettiView)
        confettiView.type = confettiType
        confettiView.colors = confettiColors
        confettiView.intensity = intensity
        confettiView.startConfetti()
        AppUtils.instance.confettiView = confettiView
    }
    
    static func hideConfetti() {
        AppUtils.instance.confettiView.stopConfetti()
        AppUtils.instance.confettiView.removeFromSuperview()
    }
}
