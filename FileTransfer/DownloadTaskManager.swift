//
//  DownloadTaskManager.swift
//  FileTransfer
//
//  Created by Bui Hai on 10/11/15.
//  Copyright © 2015 Hai Bui. All rights reserved.
//

import UIKit
import CoreData

public protocol DownloadTaskManagerObserver : class {
    
    func taskAdded (url : NSURL, saveAs filePath : NSURL)
    func taskActivated (url : NSURL, saveAs filePath : NSURL)
    func taskCompleted(url : NSURL, saveAs filePath : NSURL)
    func taskRemoved()
    func taskFailed()
    
    
}

public class DownloadTaskManager: NSObject , DownloadTaskTrackerObserver {
    
    /// the observer is informed of events related to some task
    weak public var observer : DownloadTaskManagerObserver?  = nil
    
    let persistenceSetup : DownloadTaskManagerPersistenceStackSetup

    public init(var databasesURL : NSURL? = nil) {
        
        if databasesURL == nil {
            
            var storeURL : NSURL {
                
                let defaultFileManager = NSFileManager.defaultManager()
                let appDirURL = try! defaultFileManager.URLForDirectory(NSSearchPathDirectory.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
                return appDirURL.URLByAppendingPathComponent("assets.store")
                
                
            }
            databasesURL = storeURL
            
        }
        
        persistenceSetup = DownloadTaskManagerPersistenceStackSetup(storePath: databasesURL!)
        persistenceSetup.setUpContext()
        
        
    }

    
    public func scheduleDownload (url : NSURL, saveAs fileURL : NSURL) throws{
        
        let addedTaskMetaData = NSEntityDescription.insertNewObjectForEntityForName(DownloadTaskMetaData.entityName, inManagedObjectContext: persistenceSetup.context) as! DownloadTaskMetaData
        addedTaskMetaData.dateAdded = NSDate()
        addedTaskMetaData.fileURL = fileURL.absoluteString
        addedTaskMetaData.remoteURL = url.absoluteString
        addedTaskMetaData.identifier = url.absoluteString
        addedTaskMetaData.status = NSNumber(integer: TaskStatus.Added.rawValue)
        addedTaskMetaData.summary = "Download task meta data for remote file: \(url.absoluteString)"
        try persistenceSetup.context.save()
        observer?.taskAdded(url, saveAs: fileURL)
        
    }
    
    public func deleteDownload (at url : NSURL) {
        
        observer?.taskRemoved()
        
    }
    
    
    var allDownloadTasksMetadata : [DownloadTaskMetaData]{
        
        let fetchRequest = NSFetchRequest(entityName: DownloadTaskMetaData.entityName)
        fetchRequest.predicate = NSPredicate(value: true)
        
        do {
            
            let results = try persistenceSetup.context.executeFetchRequest(fetchRequest)
            return results as! [DownloadTaskMetaData]
            
            
        } catch {
            
            return []
            
        }
        
        
        
    }
    
    
    var currentActiveTracker_ : DownloadTaskTracker? = nil
    var currentActiveTracker : DownloadTaskTracker? {
        
        guard currentActiveTracker_ == nil else {
            
            return currentActiveTracker_
            
        }
        
        
        // find next one
        for metaData in allDownloadTasksMetadata {
            
            
            
            guard checkCompleteness(metaData) == false else {
                
                continue
                
            }
            
            let downloadTask = DownloadTask(url: NSURL(string: metaData.remoteURL!)!)
            downloadTask.fileURL = NSURL(string: metaData.fileURL!)!
            currentActiveTracker_ = DownloadTaskTracker(task: downloadTask, meta: metaData)
            currentActiveTracker_?.trackerObserver = self
            break

            
        }

        return currentActiveTracker_
        
    }
    
    
    public func resume () {
        
        currentActiveTracker?.downloadTask?.resume()

        
    }
    
    
    func checkCompleteness(meta : DownloadTaskMetaData) -> Bool {
        
        if meta.status?.integerValue == TaskStatus.Done.rawValue {
            
            return true
            
        }
        
        return false
        
    }
    
    
    func downloadTaskMetaDataChanged (task: DownloadTask, tracker : DownloadTaskTracker){
        
        //persist it!
        try! persistenceSetup.context.save()
        let remoteURL = NSURL(string: (tracker.downloadTaskMetaData?.remoteURL)!)!
        let fileURL = NSURL(string: (tracker.downloadTaskMetaData?.fileURL)!)!
        switch TaskStatus(rawValue: (tracker.downloadTaskMetaData?.status?.integerValue)!)! {
            
        case .Done:
            observer?.taskCompleted(remoteURL, saveAs: fileURL)
            currentActiveTracker_ = nil
        case .Failed:
            observer?.taskFailed()
            currentActiveTracker_ = nil
        case .InProgress:
            observer?.taskActivated(remoteURL, saveAs: fileURL)
        case .Added:
            assert(false)
            
        }
        
        
    }

    
}


class DownloadTaskManagerPersistenceStackSetup : NSObject{
    
    var storePath_ : NSURL
    var storePath : NSURL {
        
        return storePath_
        
    }
    
    
    
    init (storePath : NSURL) {
        
        storePath_ = storePath
        
    }
    
    
    var context_ : NSManagedObjectContext! = nil
    var context : NSManagedObjectContext! {
        
        return context_
        
    }
    
    
    func setUpContext () {
        
        if context_ == nil {
            
            let thisBundle = NSBundle(forClass: DownloadTaskManagerPersistenceStackSetup.classForCoder())
            var managedModel_ : NSManagedObjectModel! = nil
            var persistenceCoordinator_ : NSPersistentStoreCoordinator! = nil
            managedModel_ = NSManagedObjectModel(contentsOfURL: thisBundle.URLForResource("Model", withExtension: "momd")!)
            persistenceCoordinator_ = NSPersistentStoreCoordinator(managedObjectModel: managedModel_)
            try! persistenceCoordinator_.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storePath, options: [NSInferMappingModelAutomaticallyOption:true])
            context_ = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
            context_?.persistentStoreCoordinator = persistenceCoordinator_
            
        }
        
    }
    
}


