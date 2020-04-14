//
//  CoreDataManager.swift
//  AVFoundation-MediaFeed
//
//  Created by Juan Ceballos on 4/14/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager   {
    
    // creating singleton
    private init()  {}

    static let shared = CoreDataManager()
    
    private var mediaObjects = [CDMediaObject]()
    
    // get instance of NSManagedObjectContext
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // CRUD
    
    func create(_ imageData: Data, videoURL: URL?) -> CDMediaObject   {
        let mediaObject = CDMediaObject(entity: CDMediaObject.entity(), insertInto: context)
        mediaObject.createdDate = Date()
        mediaObject.id = UUID().uuidString
        mediaObject.imageData = imageData
        if let videoURL = videoURL  { // if exist means it's a video object
            // convert url to data
            mediaObject.videoData = Data()
            do {
                mediaObject.videoData = try Data(contentsOf: videoURL)
            } catch {
                print(error)
            }
        }
        // save the newly created mediaObject entity instance to the NSManagedObjectContext
        do {
            try context.save()
        } catch {
            print("failed to save newly created media object \(error)")
        }
        return mediaObject
    }
    
    // read
    func fetchMediaObjects() -> [CDMediaObject]    {
        do  {
        mediaObjects = try context.fetch(CDMediaObject.fetchRequest())
        }
        catch   {
           print(error)
        }
        return mediaObjects
    }
    // update
    
    // delete
    
}
