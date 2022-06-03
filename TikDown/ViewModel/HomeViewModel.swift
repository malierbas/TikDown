//
//  HomeViewModel.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

class HomeViewModel {
    //desc: instance
    public static let instance = HomeViewModel()
    
    //MARK: Properties
    private let descriptionTexts = [
        "1. Press Download Video button below.",
        "2. Find your favorite video.",
        "3. Click on share button located at the right below.",
        "4. Click on Copy Link.",
        "5. Come back to this app.",
        "6. Your download will start \nautomatically. If not you can \nuse “Paste link” button too."
    ]
    
    //MARK: Functions
    //desc: set description texts to stack view
    func setDescriptionTexts(stackView: UIStackView) {
        
        //desc: create loop for items
        for (index, text) in descriptionTexts.enumerated() {
            let label = UILabel()
            label.textColor = .white
            let font = UIFont(name: "SFPRODISPLAYBOLD.OTF", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
            switch index
            {
            case 0:
                let newText = text.drawText(textToDraw: ["Download", "Video"], color: UIColor(named: "redDominant"), font: font)
                label.attributedText = newText
                label.numberOfLines = 0
                break
            case 2:
                let newText = text.drawText(textToDraw: ["share"], font: font)
                label.attributedText = newText
                label.numberOfLines = 0
                break
            case 3:
                let newText = text.drawText(textToDraw: ["Copy", "Link"], font: font)
                label.attributedText = newText
                label.numberOfLines = 0
                break
            default:
                label.font = font
                label.text = text
                label.numberOfLines = 0
                break
            }
            stackView.addArrangedSubview(label)
            stackView.sizeToFit()
        }
    }
    
    func showCopiedURLAction(vc: UIViewController) {
        if let copiedURLString = UIPasteboard.general.string,
           !copiedURLString.isEmpty {
            
            let networkManager = NetworkManager.shared
            let endpoint = Endpoints.getVideoDetails(url: copiedURLString)
            networkManager.request(endpoint) { (result: Result<VideoDataBase>) in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async { [vc] in
                        let viewController = vc.storyboard?.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
                        viewController.data = model
                        viewController.modalPresentationStyle = .fullScreen
                        vc.present(viewController, animated: true, completion: nil)
                    }
                case .error(let error):
                    print("an error occured = ", error.localizedDescription)
                }
            }
        } else {
            print("copied url not find!!")
        }
    }
    //MARK: Helper Functions
    
}
