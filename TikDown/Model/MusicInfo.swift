//
//  MusicInfo.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

struct MusicInfo: Codable {
    let id : String?
    let title : String?
    let play : String?
    let cover : String?
    let author : String?
    let original : Bool?
    let duration : Int?
    let album : String?
}
