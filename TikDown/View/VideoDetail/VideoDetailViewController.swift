//
//  VideoDetailViewController.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Photos
import AVKit
import AVFoundation
import Foundation
import UIKit

class VideoDetailViewController: BaseViewController {
    //MARK: Properties
    //desc: view
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var downloadMusicButtonOutlet: UIButton!
    @IBOutlet weak var downloadVideoButtonOutlet: UIButton!
    @IBOutlet weak var playButtonOutlet: UIButton!
    @IBOutlet weak var videoImageview: UIImageView!
    
    //desc: variables
    var awemeListDetail: AwemeList? = nil
    var dataModel: Data?
    var data: VideoDataBase? = nil
    var player: AVPlayer!
    var playerViewController: AVPlayerViewController!
    var isAweme = false
    
    var viewModel = VideoDetailViewModel.shared
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //desc: setup view
        setupView()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    //MARK: Functions
    func setupView() {
        setupAwemeList()
        
        guard let model = data else {
            print("model is unavaible!!")
            return
        }
        
        videoImageview
            .load(imageUrl: model.data?.cover)
        
        downloadMusicButtonOutlet.setTitle("Download Music", for: .normal)
        
        isAweme = false
    }
    
    func setupAwemeList() {
        guard let model = awemeListDetail, let imageURLString = model.video?.cover?.url_list?.first else {
            print("model is unavaible!!")
            return
        }
        
        videoImageview
            .load(imageUrl: imageURLString)
        
        downloadMusicButtonOutlet.setTitle("Download Music", for: .normal)
        
        isAweme = true
    }
    
    func showPlayView(playURL: URL) {
        DispatchQueue.main.async {
            let player = AVPlayer(url: playURL)
            let vc = AVPlayerViewController()
            vc.player = player
            
            self.present(vc, animated: true) {
                
                vc.player?.play()
            }
        }
    }
    
    //MARK: Actions
    @IBAction func playVideoButtonTapped(_ sender: Any) {
        if isAweme {
            guard let data = awemeListDetail,
                  let urlString = data.video?.play_addr?.url_list?.first,
                  let playURL = URL(string: urlString) else {
                return
            }

            showPlayView(playURL: playURL)
        } else {
            guard let data = data,
                  let urlString = data.data?.play,
                  let playURL = URL(string: urlString) else {
                return
            }

            showPlayView(playURL: playURL)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func downloadMusicTapped(_ sender: Any) {
        let storage = LocalStorageManager.shared
        let isPremium = storage.hasCredit ?? false
        let isClaimAll = storage.isAllCreditClaim ?? false
        print("download music detail = ", isPremium, isClaimAll)
        if (isPremium) {
            downloadMusic(storage)
        } else {
            
            if (!isPremium && !isClaimAll) {
                downloadMusic(storage)
                storage.isAllCreditClaim = true
            } else {
                AppUtils.showPaywall(on: self, callback: nil)
            }
        }
    }
    
    @IBAction func downloadVideoTapped(_ sender: Any) {
        let storage = LocalStorageManager.shared
        let isPremium = storage.hasCredit ?? false
        let isClaimAll = storage.isAllCreditClaim ?? false
        print("download music detail = ", isPremium, isClaimAll)
        if (isPremium) {
            downloadVideo(storage)
        } else {
            
            if (!isClaimAll) {
                downloadVideo(storage)
                storage.isAllCreditClaim = true
            } else {
                AppUtils.showPaywall(on: self, callback: nil)
            }
        }
    }
    
    //MARK: Helper Functions
    func downloadMusic(_ storage: LocalStorageManager) {
        AppUtils.showIndicator(on: self)
        if isAweme {
            guard let downloadURLString = awemeListDetail?.music?.play_url?.url_list?.first,
                  let downloadURL = URL(string: downloadURLString) else {
                      
                      return
                  }
            
            viewModel.downloadMusic(downloadURL: downloadURL, fileName: awemeListDetail?.aweme_id ?? "", vc: self) { fileName in
                DispatchQueue.main.async { [self] in
                    let downloadAwemeModel = DownloadAwemeModel(
                        aweme: awemeListDetail,
                        fileName: fileName
                    )
                    var awemeList: [DownloadAwemeModel] = []
                    if let awemeNewList = storage.awemeMusics { awemeList = awemeNewList }
                    awemeList.append(downloadAwemeModel)
                    storage.awemeMusics = awemeList
                    
                    if !storage.isReviewViewShowed {
                        AppUtils.showReviewView()
                        storage.isReviewViewShowed = true
                    }
                }

                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: .DownloadEndSuccess, object: nil, userInfo: nil)
                }
            }
        } else {
            
            guard let downloadURLString = data?.data?.music,
                  let downloadURL = URL(string: downloadURLString) else {
                      
                      return
                  }
            
            viewModel.downloadMusic(downloadURL: downloadURL, fileName: data?.data?.aweme_id ?? "", vc: self) { fileName in
                DispatchQueue.main.async { [self] in
                    let musicURLList = [data?.data?.music ?? ""]
                    let playURLList = [data?.data?.play ?? ""]
                    let coverData = [data?.data?.cover ?? ""]
                    let awemeModel = AwemeList(
                        aweme_id: data?.data?.aweme_id,
                        desc: data?.data?.title,
                        music: AwemeMusic(
                            play_url: AwemeMusicPlayURL(
                                url_list: musicURLList
                            )
                        ),
                        video: AwemeVideo(
                            cover: AwemeVideoCover(
                                uri: data?.data?.cover,
                                url_list: coverData
                            ),
                            play_addr: AwemeVideoPlayAddr(
                                uri: data?.data?.cover,
                                url_key: "",
                                url_list: playURLList
                            )
                        )
                    )
                    let downloadOtherModel = DownloadAwemeModel(
                        aweme: awemeModel,
                        fileName: fileName
                    )
                    
                    var otherList: [DownloadAwemeModel] = []
                    if let otherListNew = storage.awemeMusics { otherList = otherListNew }
                    otherList.append(downloadOtherModel)
                    storage.awemeMusics = otherList
                    
                    if !storage.isReviewViewShowed {
                        AppUtils.showReviewView()
                        storage.isReviewViewShowed = true
                    }
                    
                    self.dismiss(animated: true) {
                        NotificationCenter.default.post(name: .DownloadEndSuccess, object: nil, userInfo: nil)
                    }
                }
            }
        }
    }
    
    func downloadVideo(_ storage: LocalStorageManager) {
        AppUtils.showIndicator(on: self)
        if isAweme {
            guard let downloadURLString = awemeListDetail?.video?.play_addr?.url_list?.first,
                  let downloadURL = URL(string: downloadURLString) else {
                print("download url is not avaible")
                return
            }
            
            viewModel.downloadVideo(
                downloadID: awemeListDetail?.aweme_id ?? "",
                downloadURL: downloadURL,
                vc: self
            ) { fileUrl in
                DispatchQueue.main.async { [self] in
                    let storageManager = LocalStorageManager.shared
                    let downloadAwemeModel = DownloadAwemeModel(
                        aweme: awemeListDetail,
                        fileName: fileUrl
                    )
                    var awemeList: [DownloadAwemeModel] = []
                    if let awemeNewList = storageManager.awemeVideos { awemeList = awemeNewList }
                    awemeList.append(downloadAwemeModel)
                    storageManager.awemeVideos = awemeList
                    
                    if !storage.isReviewViewShowed {
                        AppUtils.showReviewView()
                        storage.isReviewViewShowed = true
                    }
                    
                    self.dismiss(animated: true) {
                        NotificationCenter.default.post(name: .DownloadEndSuccess, object: nil, userInfo: nil)
                    }
                }
            }
        } else {
            guard let downloadURLString = data?.data?.play,
                  let downloadURL = URL(string: downloadURLString) else {
                print("download url is not avaible")
                return
            }
            
            viewModel.downloadVideo(
                downloadID: data?.data?.aweme_id ?? "",
                downloadURL: downloadURL,
                vc: self
            ) { fileName in
                DispatchQueue.main.async { [self] in
                    let musicURLList = [data?.data?.music ?? ""]
                    let playURLList = [data?.data?.play ?? ""]
                    let coverData = [data?.data?.cover ?? ""]
                    let awemeModel = AwemeList(
                        aweme_id: data?.data?.aweme_id,
                        desc: data?.data?.title,
                        music: AwemeMusic(
                            play_url: AwemeMusicPlayURL(
                                url_list: musicURLList
                            )
                        ),
                        video: AwemeVideo(
                            cover: AwemeVideoCover(
                                uri: data?.data?.cover,
                                url_list: coverData
                            ),
                            play_addr: AwemeVideoPlayAddr(
                                uri: data?.data?.cover,
                                url_key: "",
                                url_list: playURLList
                            )
                        )
                    )
                    
                    let storageManager = LocalStorageManager.shared
                    let downloadOtherModel = DownloadAwemeModel(
                        aweme: awemeModel,
                        fileName: fileName
                    )
                    
                    var otherList: [DownloadAwemeModel] = []
                    if let otherListNew = storageManager.awemeVideos { otherList = otherListNew }
                    otherList.append(downloadOtherModel)
                    storageManager.awemeVideos = otherList
                    
                    if !storage.isReviewViewShowed {
                        AppUtils.showReviewView()
                        storage.isReviewViewShowed = true
                    }
                    
                    self.dismiss(animated: true) {
                        NotificationCenter.default.post(name: .DownloadEndSuccess, object: nil, userInfo: nil)
                    }
                }
            }
        }
    }
}
