//
//  TrendingCVC.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

protocol TrendingCVCDelegate: class {
    func didCellTapped(on cell: TrendingCVC, model: AwemeList?)
}

class TrendingCVC: UICollectionViewCell {
    //MARK: Properties
    //desc: views
    @IBOutlet weak var trendImageView: UIImageView!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    //desc: variables
    var data: AwemeList? {
        didSet {
            setupUI()
        }
    }
    
    var delegate: TrendingCVCDelegate? {
        didSet {
            setupGestures()
        }
    }
    
    //MARK: Functions
    func setupUI() {
        if let model = data, let imageString = model.video?.cover?.url_list?.first {
            trendImageView.load(imageUrl: imageString)
            //viewCountLabel.text = model.desc
            if let count = model.statistics?.play_count {
                viewCountLabel.text = "\(AppUtils.formatPlayCount(num: Double(count))) Views"
            }
        } else {
            print("model is unavaible!!")
        }
    }
    
    func setupGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didViewTapped(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    //MARK: Actions
    @objc func didViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didCellTapped(on: self, model: data)
    }
}
