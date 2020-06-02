//
//  SearchRequest.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation


enum Order: String {
    case asc
    case desc
}

enum Sort: String {
    case stars
    case forks
    case updated
}


struct SearchItem : Codable, Hashable, Equatable {
    public let descriptionField : String?
    public let fullName : String?
    public let homepage : String?
    public let htmlUrl : String?
    public let language : String?
    public let name : String?
    public let stargazersCount : Int?
    public let updatedAt : String?
    public let url : String?
    
    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case fullName = "full_name"
        case homepage
        case htmlUrl = "html_url"
        case language
        case name
        case stargazersCount = "stargazers_count"
        case updatedAt = "updated_at"
        case url
    }
}


struct SearchRepositoriesResponse : Codable {
    public let incomplete_results: Bool?
    public let items: [SearchItem]?
    public let total_count: Int?
}


class SearchRequest: BaseAPI {
    
    func searchRepositories(query: String, token: String?, page: Int = 1, perPage: Int = 15, sort: Sort? = .stars, order: Order = .desc, completion: @escaping APISearchCompletion) {
        let path = "https://api.github.com/search/repositories"
        var parameters = [String : String]()
        parameters["q"] = query
        parameters["order"] = order.rawValue
        if let sort = sort {
            parameters["sort"] = sort.rawValue
        }
        parameters["page"] = "\(page)"
        parameters["per_page"] = "\(perPage)"
        
        var headers = [String : String]()
        headers["Accept"] = "application/json"
        if let token = token {
            headers["Authorization"] = "token \(token)"
        }
        
        self.get(url: path, parameters: parameters, headers: headers) { (data, resp, err) in
            if let data = data {
                do {
                    let model = try JSONDecoder().decode(SearchRepositoriesResponse.self, from: data)
                    var error = err
                    var items = model.items
                    if let httpResponse = resp as? HTTPURLResponse,
                        let limitText = httpResponse.allHeaderFields["X-Ratelimit-Remaining"] as? String,
                        let limit = Int(limitText),
                        limit == 0 {
                        error = "Limit for requests"
                        items = nil
                    }
                    completion(items, error)
                } catch {
                    completion(nil, err)
                }
            } else {
                completion(nil, err)
            }
        }
    }
}
