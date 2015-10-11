//
//  DownloadTaskTracker.swift
//  FileTransfer
//
//  Created by Bui Hai on 10/11/15.
//  Copyright © 2015 Hai Bui. All rights reserved.
//

import UIKit

/// Maintain download task's status
class DownloadTaskTracker : DownloadTaskObserver {

    var downloadTask : DownloadTask? = nil
    var downloadTaskMetaData : DownloadTaskMetaData? = nil
    
    init(task: DownloadTask, meta : DownloadTaskMetaData) {
        
        downloadTask = task
        downloadTaskMetaData = meta
        task.observer = self
        
    }
    
    
    func taskStarted(task : DownloadTask) {
        
        downloadTaskMetaData?.status = NSNumber(integer: TaskStatus.InProgress.rawValue)
        
    }
    
    
    func taskDone(task : DownloadTask) {
        
        downloadTaskMetaData?.status = NSNumber(integer: TaskStatus.Done.rawValue)

        
    }
    
    
    func taskFailed(task : DownloadTask) {
        
        downloadTaskMetaData?.status = NSNumber(integer: TaskStatus.Failed.rawValue)

        
    }

}
