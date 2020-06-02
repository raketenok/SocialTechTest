//
//  AccessTokenRequest.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation

enum Parameters: String {
    case clientID = "client_id"
    case clientSecret = "client_secret"
    case code
    case redirectURL = "redirect_uri"
}

struct AccessTokenResponse: Codable {
    let access_token: String
    let token_type: String
    let scope: String
}

class AccessTokenRequest: BaseAPI {

    private let url = "https://github.com/login/oauth/access_token"
    
    func getAccessToken(clientID: String, clientSecret: String, code: String, redirectURL: String, completion: @escaping(AccessTokenResponse?, Error?) -> Void) {
        
        var parameters = [String : String]()
        parameters[Parameters.clientID.rawValue] = clientID
        parameters[Parameters.clientSecret.rawValue] = clientSecret
        parameters[Parameters.code.rawValue] = code
        parameters[Parameters.redirectURL.rawValue] = redirectURL
                
        var headers = [String : String]()
        headers["Accept"] = "application/json"
        
        self.get(url: self.url, parameters: parameters, headers: headers) { (data, _, error) in
            if let data = data {
                do {
                    let model = try JSONDecoder().decode(AccessTokenResponse.self, from: data)
                    completion(model, error)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
}



