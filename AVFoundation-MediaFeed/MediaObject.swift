//
//  MediaObject.swift
//  AVFoundation-MediaFeed
//
//  Created by Juan Ceballos on 4/13/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import Foundation

// mediaObject instance can video or image content
struct MediaObject  {
    let imageData: Data?
    let videoURL: URL?
    let caption: String?
    let id = UUID().uuidString
    let createDate = Date()
    
}
