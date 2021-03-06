//
//  MediaCell.swift
//  AVFoundation-MediaFeed
//
//  Created by Juan Ceballos on 4/13/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    
    public func configureCell(for mediaObject: CDMediaObject) {
        if let imageData = mediaObject.imageData
        {
            mediaImageView.image = UIImage(data: imageData)
        }
        
        if let videoURL = mediaObject.videoData?.convertToURL() {
            let image = videoURL.videoPreviewThumbnail() ?? UIImage(systemName: "heart")
            mediaImageView.image = image
        }
    }
}
