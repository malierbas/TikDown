//
//  ViewController.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import UIKit

class MainViewController: BaseViewController {
    //MARK: Properties
    @IBOutlet weak var topIcon: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var textsStackView: UIStackView!
    @IBOutlet weak var downloadButtonOutlet: UIButton!
    
    let homeViewModel = HomeViewModel.instance
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //desc: setup ui
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            DispatchQueue.main.async {
                self.homeViewModel.showCopiedURLAction(vc: self)
            }
        }
    }
    
    //MARK: Functions
    func setupUI() {
        downloadButtonOutlet.rounded()
        
        homeViewModel.setDescriptionTexts(stackView: textsStackView)
        
        settingsButton.increaseArea(size: 20)
        
        print("is premium = ", LocalStorageManager.shared.hasCredit)
    }
    
    //MARK: Actions
    @IBAction func downloadButtonTapped(_ sender: Any) {
        guard let tiktokURL = URL(string: "tiktok://"),
        UIApplication.shared.canOpenURL(tiktokURL) else {
            print("url cant open!!")
            return 
        }
        
        UIApplication.shared.open(tiktokURL)
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        showSettingsViewController()
    }
    
    @IBAction func pasteLinkButtonTapped(_ sender: Any) {
        self.homeViewModel.showCopiedURLAction(vc: self)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        DispatchQueue.main.asyncAfter(deadline: .now()) { [self] in
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaywallViewController") as! PaywallViewController
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true, completion: nil)
//        }
    }
}

//MARK: Extensions

