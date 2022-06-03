//
//  SearchViewModel.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

class SearchViewModel {
    //desc: instance
    public static var instance = SearchViewModel()
    
    //MARK: Properties
    func getHashtags() -> [Hashtag] {
        
        return Constants.hashtags
    }
    
    func getTrendingItems() -> [TrendingModel] {
        
        return [
            TrendingModel(
                id: 1, image: "dummyTrend", name: "trend 1", viewerCount: "1.2K Views"
            ),
            TrendingModel(
                id: 2, image: "dummyTrend", name: "trend 2", viewerCount: "2K Views"
            ),
            TrendingModel(
                id: 3, image: "dummyTrend", name: "trend 3", viewerCount: "2M Views"
            ),
            TrendingModel(
                id: 4, image: "dummyTrend", name: "trend 4", viewerCount: "2.9M Views"
            ),
            TrendingModel(
                id: 5, image: "dummyTrend", name: "trend 5", viewerCount: "1K Views"
            ),
            TrendingModel(
                id: 6, image: "dummyTrend", name: "trend 6", viewerCount: "26K Views"
            ),
            TrendingModel(
                id: 7, image: "dummyTrend", name: "trend 7", viewerCount: "1.8K Views"
            ),
            TrendingModel(
                id: 8, image: "dummyTrend", name: "trend 8", viewerCount: "10K Views"
            )
        ]
    }
    
    //MARK: LifeCycle
    
    //MARK: Actions
    
}
