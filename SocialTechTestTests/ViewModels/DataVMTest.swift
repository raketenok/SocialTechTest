//
//  DataVMTest.swift
//  SocialTechTestTests
//
//  Created by Ievgen Iefimenko on 02.06.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import XCTest
@testable import SocialTechTest

class DataVMTest: TestContainerClass {
    
    private var viewModel: DataVM!
    
    override func setUp() {
        super.setUp()
        self.viewModel = DataVM(delegate: nil, factory: self)
    }
    
    func test1Count() {
        XCTAssertTrue(self.viewModel.count() == 0, "DataVM.test1Count")
    }
    
    func test2Serching() {
        let expt = XCTestExpectation(description: "Wait for link")
        
        self.viewModel.reloadViewCallback = {
            
            XCTAssertTrue(self.viewModel.count() == 1, "DataVM.test2Serching")
            expt.fulfill()
        }
        self.viewModel.findRepo(text: "test")
        self.wait(for: [expt], timeout: 10)
    }
    
    
    func test3EmptySerching() {
        let expt = XCTestExpectation(description: "Wait for link")
        
        self.viewModel.reloadViewCallback = {
            XCTAssertTrue(self.viewModel.count() == 0, "DataVM.test3EmptySerching")
            expt.fulfill()
        }
        self.viewModel.findRepo(text: "")
        self.wait(for: [expt], timeout: 10)
    }
    
    
    func test4ItemAtIndex() {
        
        let expt = XCTestExpectation(description: "Wait for link")
        
        self.viewModel.reloadViewCallback = {
            
            let item = self.viewModel.itemAt(index: 0)
            
            XCTAssertTrue(item?.fullName == "fullName", "DataVM.test4ItemAtIndex")
            XCTAssertTrue(item?.descriptionField == "descriptionField", "DataVM.test4ItemAtIndex")
            XCTAssertTrue(item?.homepage == "homepage", "DataVM.test4ItemAtIndex")
            XCTAssertTrue(item?.name == "name", "DataVM.test4ItemAtIndex")
            XCTAssertTrue(item?.stargazersCount == 1, "DataVM.test4ItemAtIndex")
            XCTAssertTrue(item?.url == "url", "DataVM.test4ItemAtIndex")
            XCTAssertTrue(item?.updatedAt == "updatedAt", "DataVM.test4ItemAtIndex")

            expt.fulfill()
        }
        self.viewModel.findRepo(text: "test")
        self.wait(for: [expt], timeout: 10)
        
        
    }
    
    func test5LoadNextQuery() {
          self.viewModel.loadNextQuery(text: "")
          XCTAssertTrue(self.viewModel.count() == 0, "DataVM.test5LoadNextQuery")
    }
    
    func test6ShowDetail() {
        
        let expt = XCTestExpectation(description: "Wait for link")
     
        self.viewModel.reloadViewCallback = {
            self.viewModel.showDetail(index: 0)
            
            XCTAssertTrue(self.viewModel.count() == 1, "DataVM.test6ShowDetail")

            self.viewModel.findRepo(text: "test")
            
            self.viewModel.reloadViewCallback =  {
                XCTAssertTrue(self.viewModel.count() == 0, "DataVM.test6ShowDetail")
                
                expt.fulfill()
            }
        }
        self.viewModel.findRepo(text: "test")
        self.wait(for: [expt], timeout: 10)
    }
    
}
