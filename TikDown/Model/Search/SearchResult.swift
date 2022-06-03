//
//  SearchResult.swift
//  TikDown
//
//  Created by Ali on 19.05.2022.
//

import Foundation
import UIKit

struct SearchResultBase: Codable {
    var aweme_list: [AwemeList]?
    //aweme_list
    //aweme_info
}

struct AwemeList: Codable {
    var aweme_id: String?
    var desc: String?
    var music: AwemeMusic?
    var video: AwemeVideo?
    var statistics: AwemeStatistic? = nil
}

//desc: Video
struct AwemeVideo: Codable {
    var cover: AwemeVideoCover?
    var play_addr: AwemeVideoPlayAddr?
}

struct AwemeVideoCover: Codable {
    var uri: String?
    var url_list: [String]?
}

struct AwemeVideoPlayAddr: Codable {
    var uri: String?
    var url_key: String?
    var url_list: [String]?
}

//desc: Music
struct AwemeMusic: Codable {
    var play_url: AwemeMusicPlayURL?
}

struct AwemeMusicPlayURL: Codable {
    var url_list: [String]?
}

//desc: statistic
struct AwemeStatistic: Codable {
    var aweme_id: String?
    var comment_count: Int?
    var digg_count: Int?
    var download_count: Int?
    var play_count: Int?
    var share_count: Int?
}
