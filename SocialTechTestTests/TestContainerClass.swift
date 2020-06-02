//
//  TestContainerClass.swift
//  SocialTechTestTests
//
//  Created by Ievgen Iefimenko on 02.06.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import XCTest
@testable import SocialTechTest

class TestContainerClass: XCTestCase,
                            LocalSettingServiceFactory,
                            APIServiceFactory {
    
    private(set) var localSettingsSrvice: LocalSettingsService!
    private(set) var apiServie: APIService!
    
    override func setUp() {
        self.localSettingsSrvice = LocalSettingsServiceMock()
        self.apiServie = APIServiceMock(factory: self)
    }
    
    func makeLocalSettingsService() -> LocalSettingsService {
        return self.localSettingsSrvice
    }
    
    func makeAPIService() -> APIService {
        return self.apiServie
    }
    
    
}
