//
//  Tabbar+Extension.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import GoogleMobileAds
import Foundation
import UIKit

extension TabbarController: UITabBarControllerDelegate, GADBannerViewDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        Constants.generator.impactOccurred()
        return TabbarTransition(viewControllers: tabBarController.viewControllers)
    }
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.fadeIn()
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("did fail to receive ad with error = ", error.localizedDescription)
    }
}
