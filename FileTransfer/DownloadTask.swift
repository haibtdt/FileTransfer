//
//  DownloadTask.swift
//  FileTransfer
//
//  Created by Bui Hai on 10/10/15.
//  Copyright © 2015 Hai Bui. All rights reserved.
//

import UIKit

protocol DownloadTaskObserver : class{
    
    func taskStarted(task : DownloadTask)
    func taskDone(task : DownloadTask)
    func taskFailed(task : DownloadTask)
    
}

public class DownloadTask {

/// Where the complete downloaded file is stored
    public var filePath : String? = nil
    
/// The url from which the file is downloaded
    public var remoteURL : NSURL
    public init(url : NSURL) {
        
        remoteURL = url
        
    }
    
    weak var observer : DownloadTaskObserver? = nil
    
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var downloadTask : NSURLSessionDownloadTask? = nil

    /// Begin or resume the download
    public func resume () {
        
        if downloadTask == nil {
            
            downloadTask = urlSession.downloadTaskWithURL(remoteURL, completionHandler: { (url : NSURL?, res : NSURLResponse?, err : NSError?) -> Void in
                
                guard err == nil else {
                    
                    self.observer?.taskFailed(self)
                    return
                    
                }
                
           
                    
                if let _ = try? NSFileManager.defaultManager().moveItemAtPath(url!.path!, toPath: self.filePath!) {
                    
                    self.observer?.taskDone(self)
                    
                    
                } else {
                    
                    self.observer?.taskFailed(self)
                    
                }


                
            })
            downloadTask?.resume()
            observer?.taskStarted(self)
            
        }
        
        
        
    }
    
}
