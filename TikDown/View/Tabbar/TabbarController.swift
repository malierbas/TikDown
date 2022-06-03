//
//  TabbarController.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import GoogleMobileAds
import Foundation
import UIKit

class TabbarController: UITabBarController {
    //MARK: Properties
    public static var shared = TabbarController()
    
    let bannerView: GADBannerView = {
        let banner = GADBannerView()
        banner.adUnitID = Constants.testAdmobID
        banner.load(GADRequest())
        banner.backgroundColor = .secondarySystemBackground
        return banner
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //desc: setup view controllers
        setupViews()
        //desc: delegate
        delegate = self
        //desc: ads view
        setupADSView()
    }
    
    //MARK: Functions
    func setupViews() {
        var allViewControllers: [UIViewController] = []
        //desc: get view controller
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let trendingViewController = storyboard?.instantiateViewController(withIdentifier: "TrendingViewController") as! TrendingViewController
        let searchViewController = storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let savedViewController = storyboard?.instantiateViewController(withIdentifier: "SavedViewController") as! SavedViewController
        //desc: get icons
        let mainViewControllerIcon = UITabBarItem(title: "Download", image: UIImage(named: "homeTabIcon"), selectedImage: UIImage(named: "homeTabIcon"))
        let trendingViewControllerIcon = UITabBarItem(title: "Trending", image: UIImage(named: "trendTabIcon"), selectedImage: UIImage(named: "trendTabIcon"))
        let searchViewControllerIcon = UITabBarItem(title: "Search", image: UIImage(named: "searchTabIcon"), selectedImage: UIImage(named: "searchTabIcon"))
        let savedViewControllerIcon = UITabBarItem(title: "Saved", image: UIImage(named: "savedTabIcon"), selectedImage: UIImage(named: "savedTabIcon"))
        //desc: set tabbar icons
        mainViewController.tabBarItem = mainViewControllerIcon
        trendingViewController.tabBarItem = trendingViewControllerIcon
        searchViewController.tabBarItem = searchViewControllerIcon
        savedViewController.tabBarItem = savedViewControllerIcon
    
        allViewControllers.append(mainViewController)
        allViewControllers.append(trendingViewController)
        allViewControllers.append(searchViewController)
        allViewControllers.append(savedViewController)
        //desc: set view controllers
        self.viewControllers = allViewControllers
        //desc: notification
        NotificationCenter.default.addObserver(forName: .DownloadEndSuccess, object: nil, queue: .main) { notif in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.selectedIndex = 3
            }
        }
    }
    
    func setupADSView() {
        if let selfView = view {
            bannerView.rootViewController = self
            selfView
                .addSubview(bannerView)
            NSLayoutConstraint.activate([
                bannerView.widthAnchor.constraint(equalToConstant: selfView.frame.width),
                bannerView.heightAnchor.constraint(equalToConstant: 50),
                bannerView.leadingAnchor.constraint(equalTo: selfView.leadingAnchor),
                bannerView.trailingAnchor.constraint(equalTo: selfView.trailingAnchor),
                bannerView.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor)
            ])
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            bannerView.delegate = self
            bannerView.fadeOut()
        }
    }
    
    //MARK: Actions
}
