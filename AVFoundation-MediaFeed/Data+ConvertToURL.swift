//
//  Data+ConvertToURL.swift
//  AVFoundation-MediaFeed
//
//  Created by Juan Ceballos on 4/15/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import Foundation

extension Data  {
    
    // use case example:
    // let url = mediaObject.videoData.convertToURL()
    
    public func convertToURL() -> URL?  {
        
        // create a temporary url
        // NSTemporaryDirectory() - stores temporary files, those files get deleted as
        // needed by operating system
        
        // in CoreData the video is saved as data
        // when playing back the video we need to have a URL pointing to vide location on disk
        // AvPlayer needs a url pointing to a location on disk
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("mp4")
        
        do {
            try self.write(to: tempURL, options: [.atomic])
            return tempURL
        } catch  {
            print(error)
        }
        return nil
    }
}
