//
//  CDMediaObject+CoreDataProperties.swift
//  AVFoundation-MediaFeed
//
//  Created by Juan Ceballos on 4/14/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//
//

import Foundation
import CoreData


extension CDMediaObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMediaObject> {
        return NSFetchRequest<CDMediaObject>(entityName: "CDMediaObject")
    }

    @NSManaged public var id: String?
    @NSManaged public var createdDate: Date?
    @NSManaged public var videoData: Data?
    @NSManaged public var imageData: Data?
    @NSManaged public var caption: String?

}
