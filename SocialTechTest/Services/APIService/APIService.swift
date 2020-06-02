//
//  APIService.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation


protocol APIServiceFactory {
    func makeAPIService() -> APIService
}
 
extension APIServiceFactory {
    func makeAPIService() -> APIService {
        return AppManager.shared.apiService
    }
}

protocol APIService: AppService {
    
    func getAccessToken(clientID: String,
                        clientSecret: String,
                        code: String,
                        redirectURL: String,
                        completion: @escaping(AccessTokenResponse?, Error?) -> Void)
    
    func searchRepositories(query: String,
                            page: Int,
                            perPage: Int,
                            sort: Sort,
                            order: Order,
                            completion: @escaping APISearchCompletion)
}

final class APIServiceImp: APIService {
        
    typealias Factory = LocalSettingServiceFactory
    private let localSettingsService: LocalSettingsService

    init(factory: Factory = DefaultFactory()) {
        self.localSettingsService = factory.makeLocalSettingsService()
    }
    
    func getAccessToken(clientID: String,
                        clientSecret: String,
                        code: String,
                        redirectURL: String,
                        completion: @escaping (AccessTokenResponse?, Error?) -> Void) {
        AccessTokenRequest().getAccessToken(clientID: clientID,
                                            clientSecret: clientSecret,
                                            code: code,
                                            redirectURL: redirectURL,
                                            completion: { [weak self] response, error in
                                                self?.localSettingsService.aceessToken = response?.access_token
                                                completion(response, error)
        })
    }
    
    
    func searchRepositories(query: String,
                            page: Int,
                            perPage: Int,
                            sort: Sort,
                            order: Order,
                            completion: @escaping APISearchCompletion) {
        QueryRepositories().searchRepositories(query: query, token: self.localSettingsService.aceessToken, page: page, perPage: perPage, sort: sort, order: order) { (result, err) in
            completion(result, err)
        }
    }
}
