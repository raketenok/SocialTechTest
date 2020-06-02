//
//  APIServiceMock.swift
//  SocialTechTestTests
//
//  Created by Ievgen Iefimenko on 02.06.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
@testable import SocialTechTest

class APIServiceMock: APIService {
   
    typealias Factory = LocalSettingServiceFactory
    private let localSettingsService: LocalSettingsService
    
    init(factory: Factory = DefaultFactory()) {
        self.localSettingsService = factory.makeLocalSettingsService()
    }
    
    func getAccessToken(clientID: String, clientSecret: String, code: String, redirectURL: String, completion: @escaping (AccessTokenResponse?, Error?) -> Void) {
        let token = AccessTokenResponse(access_token: "access_token", token_type: "token_type", scope: "scope")
        completion(token, nil)
    }
    
    func searchRepositories(query: String, page: Int, perPage: Int, sort: Sort?, order: Order, completion: @escaping APISearchCompletion) {
        completion(self.localSettingsService.recentRepositories, nil)
    }
}
