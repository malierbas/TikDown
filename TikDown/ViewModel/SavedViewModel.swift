//
//  SavedViewModel.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

class SavedViewModel {
    //desc: instantce
    public static var instance = SavedViewModel()
    //MARK: Properties
    private let defaults = UserDefaults.standard
    
    var awemeMusics: [DownloadAwemeModel]? {
        get {
            return try? defaults.getObject(forKey: StorageNames.awemeMusics.rawValue, castTo: [DownloadAwemeModel].self)
        }
    }
    var otherMusics: [DownloadOtherModel]? {
        get {
            return try? defaults.getObject(forKey: StorageNames.otherMusics.rawValue, castTo: [DownloadOtherModel].self)
        }
    }
    
    var awemeVideos: [DownloadAwemeModel]? {
        get {
            return try? defaults.getObject(forKey: StorageNames.awemeVideos.rawValue, castTo: [DownloadAwemeModel].self)
        }
    }
    
    var otherVideos: [DownloadOtherModel]? {
        get {
            return try? defaults.getObject(forKey: StorageNames.otherVideos.rawValue, castTo: [DownloadOtherModel].self)
        }
    }
    
    //MARK: Functions
    func getMusics() -> [TrendingModel] {
        
        return [
            TrendingModel(
                id: 1,
                image: "",
                name: "Music name 1",
                viewerCount: ""
            ),
            TrendingModel(
                id: 2,
                image: "",
                name: "Music name 2",
                viewerCount: ""
            ),
            TrendingModel(
                id: 3,
                image: "",
                name: "Music name 3",
                viewerCount: ""
            ),
            TrendingModel(
                id: 4,
                image: "",
                name: "Music name 4",
                viewerCount: ""
            ),
        ]
    }
    
    func getVideos() -> [TrendingModel] {
        
        return [
            TrendingModel(
                id: 1,
                image: "dummyTrend",
                name: "Music name 1",
                viewerCount: ""
            ),
            TrendingModel(
                id: 2,
                image: "dummyTrend",
                name: "Music name 2",
                viewerCount: ""
            ),
            TrendingModel(
                id: 3,
                image: "dummyTrend",
                name: "Music name 3",
                viewerCount: ""
            ),
            TrendingModel(
                id: 4,
                image: "dummyTrend",
                name: "Music name 4",
                viewerCount: ""
            ),
        ]
    }
    
    //MARK: Helper Functions
    func deleteVideoItem(
        awemeModel: AwemeList,
        callback: ((_ completed: Bool, _ newItems: [DownloadAwemeModel]) -> Void)? = nil
    ) {
        let storageManager = LocalStorageManager.shared
        var allItems: [DownloadAwemeModel] = []
        if let dataSecond = storageManager.awemeVideos { allItems.append(contentsOf: dataSecond) }
        guard !allItems.isEmpty,
              let index = allItems.firstIndex(where: { $0.aweme!.aweme_id!.contains(awemeModel.aweme_id ?? "") }) else {
            
            return
        }
        
        allItems.remove(at: index)
        storageManager.awemeVideos = allItems
        callback?(true, allItems)
    }
}
