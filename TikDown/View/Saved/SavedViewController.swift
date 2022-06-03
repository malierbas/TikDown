//
//  SavedViewController.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import AVFoundation
import Foundation
import UIKit

class SavedViewController: BaseViewController {
    //MARK: Properties
    //desc: view
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    @IBOutlet weak var videosButtonOutlet: UIButton!
    @IBOutlet weak var musicsButtonOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var videosView: UIView!
    @IBOutlet weak var musicsView: UIView!
    @IBOutlet weak var videosCollectionview: UICollectionView!
    @IBOutlet weak var musicsCollectionview: UICollectionView!
    @IBOutlet weak var hasNoVideoView: UIView!
    @IBOutlet weak var hasNoMusicView: UIView!
    
    //desc: variables
    var currentAlert: UIAlertController? = nil
    var lastCell: SavedMusicsCVC!
    var player: AVAudioPlayer?
    var savedViewModel = SavedViewModel.instance
    var musics: [DownloadAwemeModel] = [] {
        didSet {
            musicsCollectionview.reloadData()
            print("values = ", musics)
        }
    }
    var videos: [DownloadAwemeModel] = [] {
        didSet {
            videosCollectionview.reloadData()
            print("videos = ", videos)
        }
    }
    
        
    var videosSelected = false {
        didSet {
            changeViewState()
        }
    }
    
    var selectionColor = UIColor.white
    var unselectionColor = UIColor.gray.withAlphaComponent(0.45)
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //desc: setup ui
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupNoMusic()
        setupNoVideo()
        
        musics.removeAll()
        videos.removeAll()
        
        if let musicsData = savedViewModel.awemeMusics { musics = musicsData }
        if let videoData = savedViewModel.awemeVideos { videos = videoData }
        
        settingsButtonOutlet.increaseArea(size: 10)
    }
    
    //MARK: Functions
    func setupUI() {
        videosSelected = true
        //desc: setup width again
        NSLayoutConstraint.activate([
            scrollContentView.widthAnchor.constraint(equalToConstant: view.frame.width * 2),
            videosView.widthAnchor.constraint(equalToConstant: view.frame.width),
            musicsView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        
        musicsCollectionview.dataSource = self
        videosCollectionview.dataSource = self
        
        if let musicsData = savedViewModel.awemeMusics { musics = musicsData }
        if let videoData = savedViewModel.awemeVideos { videos = videoData }
    }
    
    //MARK: Actions
    @IBAction func videosButtonTapped(_ sender: Any) {
        videosSelected = true
    }
    
    @IBAction func musicsButtonTapped(_ sender: Any) {
        videosSelected = false
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        showSettingsViewController()
    }
    
    @IBAction func saveNowVideoTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }
    
    //MARK: Helper Functions
    func changeViewState() {
        if (videosSelected) {
            selectVideos()
        } else {
            selectMusic()
        }
    }
    
    func selectMusic() {
        musicsButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        videosButtonOutlet.setTitleColor(UIColor.systemGray.withAlphaComponent(0.45), for: .normal)
        
        let offsetPoint = view.frame.width
        scrollView.updateFrame(newOffsetPoint: offsetPoint)
    }
    
    func selectVideos() {
        videosButtonOutlet.setTitleColor(UIColor.white, for: .normal)
        musicsButtonOutlet.setTitleColor(UIColor.systemGray.withAlphaComponent(0.45), for: .normal)
        
        let offsetPoint = view.frame.width * 0
        scrollView.updateFrame(newOffsetPoint: offsetPoint)
    }
    
    func setupNoVideo() {
        let storageManager = LocalStorageManager.shared
        
        if let videos = storageManager.awemeVideos, !videos.isEmpty  {
        } else {
            videosCollectionview.fadeOut() {
                
                self.hasNoVideoView.setRadius(radii: 8)
                self.hasNoVideoView.fadeIn()
            }
        }
    }
    
    func setupNoMusic() {
        let storageManager = LocalStorageManager.shared
        
        if let musics = storageManager.awemeMusics, !musics.isEmpty {
        } else {
            musicsCollectionview.fadeOut() {
                
                self.hasNoMusicView.setRadius(radii: 8)
                self.hasNoMusicView.fadeIn()
            }
        }
    }
    
    @objc func hideAlert(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
            self.currentAlert = nil
            print("tapped!!")
        }
    }
}

//MARK: Extensions
//desc: scroll view
extension SavedViewController: UIScrollViewDelegate {
    
}

//desc: collection view
extension SavedViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView
        {
        case musicsCollectionview:
            return musics.count
        case videosCollectionview:
            return videos.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView
        {
        case musicsCollectionview:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedMusicsCVC", for: indexPath) as! SavedMusicsCVC
            let musicData = musics[indexPath.row]
            cell.data = musicData
            cell.delegate = self
            return cell
        case videosCollectionview:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SavedVideosCVC", for: indexPath) as! SavedVideosCVC
            let videosData = videos[indexPath.row]
            cell.data = videosData
            cell.delegate = self
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension SavedViewController: SavedMusicsCVCDelegate {
    func didCellTapped(on cell: SavedMusicsCVC, model: DownloadAwemeModel?) {
        lastCell = cell
        
        if cell.isPlaying {
            player?.stop()
            cell.isPlaying = false
        } else {
            guard let model = model else {
                return
            }

            AppUtils.getDownloadedMusic(
                fileName: model.fileName ?? ""
            ) { fileName in
                guard let fileName = fileName else  {
                    
                    return
                }
                
                do {
                    let fileURL = URL(fileURLWithPath: fileName)
                    self.player = try AVAudioPlayer(contentsOf: fileURL)
                    self.player?.play()
                    self.player?.delegate = self
                    cell.isPlaying = true
                } catch {
                    print("an error occured = ", error.localizedDescription)
                    cell.isPlaying = false
                }
            }
        }
    }
}

extension SavedViewController: SavedVideosCVCDelegate {
    func didCellTapped(on cell: SavedVideosCVC, model: DownloadAwemeModel?) {
        guard let awemeModel = model?.aweme else {
            return
        }

        AppUtils.getDownloadedImage(
            fileName: awemeModel.aweme_id ?? ""
        ) { fileName in
            guard let fileName = fileName,
                  let fileURL = try? URL(fileURLWithPath: fileName) else {
                
                return
            }
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.motionCancelled(.remoteControlEndSeekingBackward, with: nil)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            let actionShare =  UIAlertAction(
                title: "Repost",
                style: .default,
                handler: { _ in
                    AppUtils.shareWithOtherApps(filePath: fileURL.path, vc: self)
                }
            )
            let actionSave =  UIAlertAction(
                title: "Save",
                style: .default,
                handler: { _ in
                    AppUtils.saveToLibrary(filePath: fileURL.path, vc: self) { completed in
                        AppUtils.showSuccessAlert(on: self, true, false)
                    }
                }
            )
            let actionPlay = UIAlertAction(
                title: "Play",
                style: .default) { _ in
                    AppUtils.showPlayerView(playURL: fileURL, self)
                }
            let actionDelete =  UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: { _ in
                    guard let aweme = model?.aweme else {
                        
                        return 
                    }
                    
                    self.savedViewModel.deleteVideoItem(
                        awemeModel: aweme
                    ) { completed, newData in
                        AppUtils.showSuccessAlert(on: self, true, true)
                        self.videos = newData
                    }
                }
            )
            
            alert.addAction(actionShare)
            alert.addAction(actionSave)
            alert.addAction(actionPlay)
            alert.addAction(actionDelete)
            alert.addAction(cancelAction)
            
            alert.view.superview?.isUserInteractionEnabled = true
            let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideAlert(_:)))
            alert.view.superview?.addGestureRecognizer(dismissGesture)
            self.currentAlert = alert
            
            self.present(alert, animated: true)
        }
    }
}

extension SavedViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        self.lastCell.isPlaying = false
        self.player = nil
    }
}
