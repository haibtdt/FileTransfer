//
//  DownloadTaskMetaData+CoreDataProperties.swift
//  FileTransfer
//
//  Created by Bui Hai on 10/11/15.
//  Copyright © 2015 Hai Bui. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DownloadTaskMetaData {

    @NSManaged var dateAdded: NSDate?
    @NSManaged var fileURL: String?
    @NSManaged var identifier: String?
    @NSManaged var remoteURL: String?
    @NSManaged var status: NSNumber?
    @NSManaged var summary: String?

}
