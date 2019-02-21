//
//  NetworkManager.swift
//  MusicList
//
//  Created by Morsu  sharat on 2/2/19.
//  Copyright © 2019 Morsu  Sharat. All rights reserved.
//

import Foundation

public let MUSIC_LIST_URL = "http://rss.itunes.apple.com/api/v1/us/apple-music/new-releases/all/100/explicit.json"

public typealias ResponseHandler = ( _ jsonDict: [String:Any]?, _ error: Error?) -> ()

class NetworkManager {
    
    public static let shared = NetworkManager()
    
    private init() { }
    
    func callService(urlString: String, completionHandler: @escaping ResponseHandler) {
        guard let url = URL(string: urlString) else {
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { (jsonData, httpUrlResponse, error) in
            if let errorResponse = error {
                completionHandler(nil, errorResponse)
            }
            else if let dataResponse = jsonData {
                do {
                    let json = try JSONSerialization.jsonObject(with: dataResponse, options: .mutableLeaves)
                    completionHandler(json as? [String:Any], nil)
                }
                catch let error {
                    completionHandler(nil, error)
                }
            }
        }
        dataTask.resume()
    }
    
}
