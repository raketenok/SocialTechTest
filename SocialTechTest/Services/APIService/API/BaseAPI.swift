//
//  BaseAPI.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation


class BaseAPI {
    
    private let session: URLSession
    
    init() {
        self.session = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    public func get(url: String, parameters: [String : String]? = nil, headers: [String: String]? = nil, completion: @escaping APICompletion) {
        let request = Request(url: url, method: "GET", parameters: parameters, headers: headers, body: nil)
        let buildRequest = request.request()
        if let urlRequest = buildRequest.request {
            let task = session.dataTask(with: urlRequest, completionHandler: completion)
            task.resume()
        } else {
            completion(nil, nil, buildRequest.error)
        }
    }
    
}
