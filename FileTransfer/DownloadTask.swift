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
    public var fileURL : NSURL? = nil
    
/// The url from which the file is downloaded
    public var remoteURL : NSURL
    public init(url : NSURL) {
        
        remoteURL = url
        
    }
    
    weak var observer : DownloadTaskObserver? = nil
    
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var downloadTask : NSURLSessionDownloadTask? = nil

    /// Begin the download
    public func resume () {
        
        if downloadTask == nil {
            
            downloadTask = urlSession.downloadTaskWithURL(remoteURL,
                completionHandler: { (url : NSURL?, res : NSURLResponse?, err : NSError?) -> Void in
                
                guard err == nil else {
                    
                    self.observer?.taskFailed(self)
                    return
                    
                }
                
           
                do {
                    
                    try NSFileManager.defaultManager().moveItemAtURL(url!, toURL: self.fileURL!)
                    self.observer?.taskDone(self)
                    

                } catch {
                    
                    print(error as NSError)
                    self.observer?.taskFailed(self)
                    
                }


                
            })
            downloadTask?.resume()
            observer?.taskStarted(self)
            
        }
        
        
    }
    
    public func stop () {
        
        downloadTask?.cancel()
        
    }
    
}
