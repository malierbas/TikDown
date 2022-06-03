//
//  SearchCell.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

protocol SearchTVCDelegate: class {
    func didCellTapped(on cell: SearchTVC, withHashtag: Hashtag?)
}

class SearchTVC: UITableViewCell {
    //MARK: Properties
    //desc: views
    @IBOutlet weak var hashtagLabel: UILabel!
    
    //desc: variables
    var data: Hashtag? {
        didSet {
             setupView()
        }
    }
    
    var delegate: SearchTVCDelegate? {
        didSet {
            setupGestures()
        }
    }
    
    //MARK: LifeCycle
    func setupView() {
        if let hashtag = data {
            hashtagLabel.text = "#\(hashtag)"
        } else {
            print("hashtag is unavaible!!")
        }
    }
    
    func setupGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didViewTapped(_:)))
        addGestureRecognizer(gesture)
    }
    
    //MARK: Actions
    @objc func didViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didCellTapped(on: self, withHashtag: data)
    }
}
