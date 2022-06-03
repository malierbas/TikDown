//
//  DownloadData.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

struct DownloadData: Codable {
    let aweme_id : String?
    let id : String?
    let region : String?
    let title : String?
    let cover : String?
    let origin_cover : String?
    let play : String?
    let wmplay : String?
    let music : String?
    let music_info : MusicInfo?
    let play_count : Int?
    let digg_count : Int?
    let comment_count : Int?
    let share_count : Int?
    let download_count : Int?
    let create_time : Int?
    let author : Authdor?
}
