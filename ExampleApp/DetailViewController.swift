//
//  DetailViewController.swift
//  ExampleApp
//
//  Created by Hai Bui on 10/9/15.
//  Copyright © 2015 Hai Bui. All rights reserved.
//

import UIKit
import FileTransfer

class DetailViewController: UIViewController, DownloadTaskManagerObserver {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    
    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var remoteURLField: UITextField!
    var saveDirURL : NSURL {
        
        let defaultManager = NSFileManager.defaultManager()
        return defaultManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
        
        
        
    }
    
    var downloadManager_ : DownloadTaskManager? = nil
    var downloadManager : DownloadTaskManager {
        
        if downloadManager_ == nil {
            
            downloadManager_ = DownloadTaskManager()
            downloadManager_?.observer = self
            
        }
        return downloadManager_!
        
    }
    
    @IBAction func startDownload(sender: AnyObject) {
        
        downloadManager.resume()
        
    }
    
    
    @IBAction func addDownloadTask(sender: AnyObject) {
        
        
        guard remoteURLField.text!.isEmpty == false else {
            
            return
            
        }
        
        if let remoteURL = NSURL(string: remoteURLField.text!) {
            
            let fileURL = saveDirURL.URLByAppendingPathComponent(remoteURL.lastPathComponent ?? "no_name")
            if let _ = try? downloadManager.scheduleDownload(remoteURL, saveAs: fileURL) {
                
                print("added \(remoteURL) with save path: \(fileURL)")

                
            } else {
                
                print("failed to add task with \(remoteURL) to save path: \(fileURL)")
                
            }
            
            
        }

        
        
    }
    

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func taskAdded (url : NSURL, saveAs filePath : NSURL){
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.taskStatusLabel.text = "added \(url) as a task and will be saved at \(filePath)"
            
            
        }

    }
    
    
    func taskActivated (url : NSURL, saveAs filePath : NSURL){
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            

            self.taskStatusLabel.text = "activated \(url) as a task and will be saved at \(filePath)"
            
            
        }


        
    }
    
    
    func taskCompleted(url : NSURL, saveAs filePath : NSURL) {
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            

            self.taskStatusLabel.text = "completed \(url) as a task and will be saved at \(filePath)"

            
        }

 
        
    }
    
    
    func taskRemoved(){
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            
            
        }

        
    }
    
    
    func taskFailed(){
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.taskStatusLabel.text = "task faied"

            
        }

        
    }



}

