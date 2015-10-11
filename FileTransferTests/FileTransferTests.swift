//
//  FileTransferTests.swift
//  FileTransferTests
//
//  Created by Hai Bui on 10/9/15.
//  Copyright © 2015 Hai Bui. All rights reserved.
//

import XCTest
@testable import FileTransfer

class FileTransferTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDownloadTask_OnCreation_AcceptsURL () {
        
        let url = NSURL(string: "http://google.vn")!
        let downloadTask = makeDownloadTask(url)
        
        let someOtherURL = NSURL(string: "http://apple.com")!
        XCTAssertNotEqual(someOtherURL, downloadTask.remoteURL)
        
        
    }
    
    func testDownloadTask_AfterCreation_AllowsSettingFilePath () {
        
        let url = NSURL(string: "http://google.vn")!
        let downloadTask = makeDownloadTask(url)

        let filePath = "/var/app/myfile.ext"
        downloadTask.filePath = filePath
        XCTAssertEqual(filePath, downloadTask.filePath)
        
        let anotherFilePath = "var/app/some_otherfile.ext"
        XCTAssertNotEqual(anotherFilePath, downloadTask.filePath)
        
        
    }
    
    func testDownloadTask_WhenErrorOccured_NotifiesTheObserver () {
        
        
        
    }
    
    func makeDownloadTask (url : NSURL) -> DownloadTask {
        
        let aDownloadTask = DownloadTask(url: url)
        XCTAssertEqual(url, aDownloadTask.remoteURL)
        return aDownloadTask
        
    }
    
}
