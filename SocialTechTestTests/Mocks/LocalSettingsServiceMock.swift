//
//  LocalSettingsServiceMock.swift
//  SocialTechTestTests
//
//  Created by Ievgen Iefimenko on 02.06.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation

@testable import SocialTechTest

class LocalSettingsServiceMock: LocalSettingsService {
   
    func updateRecentItem(item: SearchItem) {
        self.recentRepositories.removeAll()
    }
    
    var recentRepositories: [SearchItem]
    var aceessToken: String?
    
    init() {

        self.aceessToken = "testToken"
        let item = SearchItem(descriptionField: "descriptionField", fullName: "fullName", homepage: "homepage", htmlUrl: "htmlUrl", language: "language", name: "name", stargazersCount: 1, updatedAt: "updatedAt", url: "url")
        self.recentRepositories = [item]
    }

}
