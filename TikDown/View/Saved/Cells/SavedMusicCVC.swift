//
//  SavedMusicCVC.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import UIKit

protocol SavedMusicsCVCDelegate: class {
    func didCellTapped(on cell: SavedMusicsCVC, model: DownloadAwemeModel?)
}

class SavedMusicsCVC: UICollectionViewCell {
    //MARK: Properties
    //desc: views
    @IBOutlet weak var buttonMusic: UIImageView!
    @IBOutlet weak var savedMusicNameLabel: UILabel!
    
    //desc: variables
    var data: DownloadAwemeModel? {
        didSet {
            setupView()
        }
    }
    
    var delegate: SavedMusicsCVCDelegate? {
        didSet {
            setupGesture()
        }
    }
    
    var isPlaying = false {
        didSet {
            buttonMusic.set(isPlaying ? "pause.fill" : "play.fill", true)
            
            if (!isPlaying) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                    
                    buttonMusic.set("soundIcon", false)
                }
            }
        }
    }
    
    //MARK: LifeCycle
    func setupView() {
        if let data = data {
            savedMusicNameLabel.text = data.aweme?.desc ?? ""
        } else {
            print("data not avaible!!")
        }
    }
    
    func setupGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didViewTapped(_:)))
        addGestureRecognizer(gesture)
    }
    
    //MARK: Actions
    @objc func didViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didCellTapped(on: self, model: data)
    }
}
