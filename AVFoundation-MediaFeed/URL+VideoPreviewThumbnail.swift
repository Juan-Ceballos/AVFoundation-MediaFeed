//
//  URL+VideoPreviewThumbnail.swift
//  AVFoundation-MediaFeed
//
//  Created by Juan Ceballos on 4/13/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import AVFoundation

extension URL   {
    
    // create an AVAsset Instance
    // e.g. mediaObject.videoURL
    public func videoPreviewThumbnail() -> UIImage? {
        let asset = AVAsset(url: self) // self is th url Instance
        
        // The AVAssetImageGenerator is an AVFoundation class that converts a given media url to an image
        
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        
        assetGenerator.appliesPreferredTrackTransform = true
        
        // create a timestamp of needed location in the video
        // we will use a CMTime to generate the given timestamp
        // CMTime is part of Core Media
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        // retrieve the first second of the video
        
        var image: UIImage?
        
        do {
            let cgImage = try assetGenerator.copyCGImage(at: timestamp, actualTime: nil)
            image = UIImage(cgImage: cgImage)
            // lower level api don't know about UIKit, AVKit \
            // change the color of the UIView Border
            // e.g. someView.layer.borderColor = UIColor.green.cgColor
        } catch  {
            print("failed image extension error")
        }
        
        return image
    }
}
