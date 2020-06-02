//
//  MainVM.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import UIKit

protocol MainVMDelegate: class {
    func successLogin()
}

class MainVM: ViewModel {
    
    typealias Factory = APIServiceFactory
    private let apiService: APIService
    private weak var delegate: MainVMDelegate?
    
    init(delegate: MainVMDelegate?, factory: Factory = DefaultFactory()) {
        self.apiService = factory.makeAPIService()
        self.delegate = delegate
    }
    
    func getAccessToken(url: String, code: String) {
        guard url == Constant.redirectURL else { return }
        
        self.apiService.getAccessToken(clientID: Constant.clientID, clientSecret: Constant.clientSecret, code: code, redirectURL: Constant.redirectURL) { [weak self] (response, err) in
            
            guard let error = err else {
                DispatchQueue.main.async {
                    self?.delegate?.successLogin()
                }
                return
            }
            self?.baseVew?.errorAlert(error)
        }
    }
    
    func buildURL(allowSignup: Bool) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "github.com"
        urlComponents.path = "/login/oauth/authorize"
        let redirectURIQueryItem = URLQueryItem(name: "redirect_uri", value: "\(Constant.redirectURL)")
        let allowSignupQueryItem = URLQueryItem(name: "allow_signup", value: "\(allowSignup ? "true" : "false")")
        let clientIDQueryItem = URLQueryItem(name: "client_id", value: Constant.clientID)
        urlComponents.queryItems = [redirectURIQueryItem, allowSignupQueryItem, clientIDQueryItem]
        return urlComponents.url!
    }
    
}