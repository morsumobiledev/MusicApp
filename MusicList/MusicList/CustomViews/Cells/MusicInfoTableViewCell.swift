//
//  MusicInfoTableViewCell.swift
//  MusicList
//
//  Created by Morsu  sharat on 2/2/19.
//  Copyright © 2019 Morsu  Sharat. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil, let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
}

class MusicInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpUI(musicInfo: MusicInfo) {
        artistName.text = musicInfo.artistName
        songName.text = musicInfo.songName
        if let songImageUrl = musicInfo.imageUrl {
            songImageView.downloaded(from: songImageUrl)
        }
    }
    
}
