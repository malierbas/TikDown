//
//  SavedVideosCVC.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import UIKit

protocol SavedVideosCVCDelegate: class {
    func didCellTapped(on cell: SavedVideosCVC, model: DownloadAwemeModel?)
}

class SavedVideosCVC: UICollectionViewCell {
    //MARK: Properties
    //desc: views
    @IBOutlet weak var videoImageView: UIImageView!
    
    //desc: variables
    var data: DownloadAwemeModel? {
        didSet {
            setupView()
        }
    }
    
    var delegate: SavedVideosCVCDelegate? {
        didSet {
            setupGesture()
        }
    }
    
    //MARK: LifeCycle
    func setupView() {
        if let data = data, let imageURLString = data.aweme?.video?.cover?.url_list?.first {
            videoImageView.load(imageUrl: imageURLString)
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
