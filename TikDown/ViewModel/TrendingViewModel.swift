//
//  TrendingViewModel.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

class TrendingViewModel {
    //desc: instance
    public static var instance = TrendingViewModel()
    //MARK: Properties
    
    //MARK: Functions
    func getTrendingItems(callback: (([AwemeList]) -> Void)? = nil) {
        let networking = NetworkManager.shared
        let endpoint = Endpoints.feed(region: "US")
        networking.request(endpoint) { (result: Result<SearchResultBase>) in
            switch result {
            case .success(let data):
                let list = data.aweme_list
                guard let list = list else {
                    return
                }

                callback?(list)
                break
            case .error(let error):
                print("an error occured = ", error.localizedDescription)
            }
        }
    }
    
    //MARK: Helper Functions
}
