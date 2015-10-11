//
//  DownloadTaskManager.swift
//  FileTransfer
//
//  Created by Bui Hai on 10/11/15.
//  Copyright © 2015 Hai Bui. All rights reserved.
//

import UIKit

public protocol DownloadTaskManagerObserver : class {
    
    func taskAdded ()
    func taskCompleted()
    func taskRemoved()
    func taskFailed()
    
    
}

public class DownloadTaskManager: NSObject {
    
    weak public var observer : DownloadTaskManagerObserver?  = nil

    public func scheduleDownload (url : NSURL, saveAs filePath : NSURL) {
        
        observer?.taskAdded()
        
    }
    
    public func deleteDownload (at url : NSURL) {
        
        observer?.taskRemoved()
        
    }
    
    public func resume () {
        
        
        
    }
    
}
