//
//  Request.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation


typealias APICompletion = (Data?, URLResponse?, Error?) -> Void
typealias APISearchCompletion = ([SearchItem]?, Error?) -> Void

class Request {
    
    private let url: String
    private let method: String
    private let parameters: [String : String]?
    private let headers: [String : String]?
    private let body: Data?
    
    init(url: String, method: String, parameters: [String : String]? = nil, headers: [String : String]? = nil, body: Data? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.body = body
    }
    
    func request() -> (request: URLRequest?, error: Error?) {
        let url = URL(string: self.urlWithParams())
        if let url = url {
            var request = URLRequest(url: url)
            if let headers = self.headers {
                for headerKey in headers.keys {
                    request.addValue(headers[headerKey]!, forHTTPHeaderField: headerKey)
                }
            }
            request.httpMethod = method
            request.httpBody = body
            return (request, nil)
        } else {
            return (nil, "Unable to create URL")
        }
    }
    
    private func urlWithParams() -> String {
        var retUrl = self.url
        if let parameters = self.parameters {
            if parameters.count > 0 {
                retUrl.append("?")
                parameters.keys.forEach {
                    guard let value = parameters[$0] else { return }
                    retUrl.append("\($0)=\(value)&")
                }
                retUrl.removeLast()
            }
        }
        return retUrl
    }
}
