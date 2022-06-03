//
//  BaseViewController.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    //MARK: Show settings
    func showSettingsViewController() {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
}
