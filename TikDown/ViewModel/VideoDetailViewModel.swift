//
//  VideoDetailViewModel.swift
//  TikDown
//
//  Created by Ali on 19.05.2022.
//

import Foundation
import Photos
import UIKit

class VideoDetailViewModel {
    //MARK: Properties
    public static var shared = VideoDetailViewModel()
    
    //MARK: Functions
    func downloadVideo(
        downloadID: String,
        downloadURL: URL?,
        vc: UIViewController,
        callback: ((String?) -> Void)? = nil
    ) {
        DispatchQueue.global(qos: .background).async {
            do {
                guard let downloadURL = downloadURL else {
                    DispatchQueue.main.async { AppUtils.hideIndicator(on: vc) }
                    return
                }
                let downloadURLData = try Data(contentsOf: downloadURL)
                guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
                    DispatchQueue.main.async { AppUtils.hideIndicator(on: vc) }
                    return
                }
                let filePath = "\(documentsPath)/\(downloadID).mp4"
                
                let documentsURL = URL(fileURLWithPath: filePath)
                try downloadURLData.write(to: documentsURL)
                DispatchQueue.main.async {
                    callback?(downloadID)
                    AppUtils.hideIndicator(on: vc)
                    UIPasteboard.general.string = ""
                }
            } catch {
                DispatchQueue.main.async {
                    print("an error occured = ", error.localizedDescription)
                    AppUtils.hideIndicator(on: vc)
                    callback?(nil)
                }
            }
        }
    }
    
    func downloadMusic(
        downloadURL: URL?,
        fileName: String,
        vc: UIViewController,
        callback: ((String?) -> Void)? = nil
    ) {
        DispatchQueue.global(qos: .background).async {
            do {
                guard let downloadURL = downloadURL else {
                    DispatchQueue.main.async { AppUtils.hideIndicator(on: vc) }
                    return
                }
                
                let downloadURLData = try Data(contentsOf: downloadURL)
                guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
                    DispatchQueue.main.async { AppUtils.hideIndicator(on: vc) }
                    return
                }
                
                
                let filePath = "\(documentsPath)/\(fileName).mp3"
                let documentsURL = URL(fileURLWithPath: filePath)
                
                try downloadURLData.write(to: documentsURL)
                
                DispatchQueue.main.async {
                    print("download url data = \(downloadURLData) = ", documentsURL)
                    callback?(fileName)
                    AppUtils.hideIndicator(on: vc)
                }
                
            } catch {
                DispatchQueue.main.async {
                    print("an error occured = ", error.localizedDescription)
                    AppUtils.hideIndicator(on: vc)
                    callback?(nil)
                }
            }
        }
    }
    
    //MARK: Actions
    
    //MARK: Helper Functions
}
