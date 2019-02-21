//
//  MusicInfo.swift
//  MusicList
//
//  Created by Morsu  sharat on 2/2/19.
//  Copyright © 2019 Morsu  Sharat. All rights reserved.
//

import Foundation

struct MusicInfo {
    var artistName: String?
    var songName: String?
    var imageUrl: String?
    
    init(musicInfoDict: [String: Any]) {
        self.artistName = musicInfoDict["artistName"] as? String
        self.songName = musicInfoDict["name"] as? String
        self.imageUrl = musicInfoDict["artworkUrl100"] as? String
    }
    
}
