//
//  TFTweetPhoto.swift
//  TwitterFeed
//
//  Created by Alexandr Gaidukov on 02.02.16.
//  Copyright © 2016 Alexandr Gaidukov. All rights reserved.
//

import Foundation

class TFTweetPhoto {
    var imageURL: String!
    var imageWidth: Double = 0.0
    var imageHeight: Double = 0.0
    
    init(params: NSDictionary) {
        if let url = params["media_url"] as? String {
            self.imageURL = url
        }
        
        if let sizes = params["sizes"]?["large"] as? NSDictionary {
            if let width = sizes["w"] as? Double {
                imageWidth = width
            }
            
            if let height = sizes["h"] as? Double {
                imageHeight = height
            }
        }
    }
}