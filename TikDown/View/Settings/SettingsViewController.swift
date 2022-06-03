//
//  SettingsViewController.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

class SettingsViewController: BaseViewController {
    //MARK: Properties
    //desc: views
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //desc: variables
    let tabs = SettingsTabs.allCases
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //desc: setup ui
        setupUI()
    }
    
    //MARK: Functions
    func setupUI() {
        tableView.dataSource = self
        tableView.reloadData()
        
        backButtonOutlet.increaseArea(size: 10)
    }
    
    //MARK: Actions
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helper Functions
}

//MARK: Extension
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTVC", for: indexPath) as! SettingsTVC
        let data = tabs[indexPath.row]
        cell.settingsTab = data
        cell.delegate = self
        return cell
    }
}

extension SettingsViewController: SettingsTVCDelegate {
    func didCellTapped(on cell: SettingsTVC, selectedTab: SettingsTabs) {
        switch selectedTab
        {
        case .shareApp:
            DispatchQueue.main.async { 
                let activityViewController = UIActivityViewController(
                  activityItems: ["http://itunes.apple.com/app/1625337675"],
                  applicationActivities: nil)

                self.present(activityViewController, animated: true, completion: nil)
            }
            break
        case .contactUs:
            DispatchQueue.main.async {
                guard let appURL = URL(string: "mailto:hello@piple.co"),
                      UIApplication.shared.canOpenURL(appURL)  else {
                    
                    return
                }

                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            }
            break
        case .restorePurchase:
            let paywallViewModel = PaywallViewModel.instance
            paywallViewModel.restoreProdut()
            break
        case .reviewUs:
            DispatchQueue.main.async {
                AppStoreReviewManager.requestReviewIfAppropriate()
            }
            break
        case .privacyPolicy:
            DispatchQueue.main.async {
                guard let url = URL(string: "https://sites.google.com/view/wordleap-privacy/home"),
                      UIApplication.shared.canOpenURL(url) else {
                    
                    return
                }
                
                UIApplication.shared.open(url)
            }
            break
        }
    }
}
