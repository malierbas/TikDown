//
//  SettingsTVC.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

protocol SettingsTVCDelegate: class {
    func didCellTapped(on cell: SettingsTVC, selectedTab: SettingsTabs)
}

class SettingsTVC: UITableViewCell {
    //MARK: Properties
    //desc: views
    @IBOutlet weak var tabNameLabel: UILabel!
    
    //desc: variables
    var settingsTab: SettingsTabs! {
        didSet {
            setupView()
        }
    }
    
    var delegate: SettingsTVCDelegate? {
        didSet {
            setupGestures()
        }
    }
    
    //MARK: LifeCycle
    func setupView() {
        if let settingsTab = settingsTab {
            tabNameLabel.text = settingsTab.rawValue
        } else {
            print("settings tab is unavaible!!")
        }
    }
    
    func setupGestures() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didViewTapped(_:)))
        addGestureRecognizer(gesture)
    }
    
    //MARK: actions
    @objc func didViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.didCellTapped(on: self, selectedTab: settingsTab)
    }
}
