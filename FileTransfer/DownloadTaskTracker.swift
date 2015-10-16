//
//  DownloadTaskTracker.swift
//  FileTransfer
//
//  Created by Bui Hai on 10/11/15.
//  Copyright © 2015 Hai Bui. All rights reserved.
//

import UIKit

protocol DownloadTaskTrackerObserver : class {
    
    func downloadTaskMetaDataChanged (task: DownloadTask, tracker : DownloadTaskTracker)
    
}

/// Maintain download task's status
class DownloadTaskTracker : DownloadTaskObserver {

    var downloadTask : DownloadTask? = nil
    var downloadTaskMetaData : DownloadTaskMetaData? = nil
    weak var trackerObserver : DownloadTaskTrackerObserver? = nil
    
    
    init(task: DownloadTask, meta : DownloadTaskMetaData) {
        
        downloadTask = task
        downloadTaskMetaData = meta
        task.observer = self
        
    }
    
    
    func taskStarted(task : DownloadTask) {
        
        downloadTaskMetaData?.status = NSNumber(integer: TaskStatus.InProgress.rawValue)
        trackerObserver?.downloadTaskMetaDataChanged(task, tracker: self)
        
    }
    
    
    func taskDone(task : DownloadTask) {
        
        downloadTaskMetaData?.status = NSNumber(integer: TaskStatus.Done.rawValue)
        trackerObserver?.downloadTaskMetaDataChanged(task, tracker: self)

        
    }
    
    
    func taskFailed(task : DownloadTask) {
        
        downloadTaskMetaData?.status = NSNumber(integer: TaskStatus.Failed.rawValue)
        trackerObserver?.downloadTaskMetaDataChanged(task, tracker: self)

        
    }

}
