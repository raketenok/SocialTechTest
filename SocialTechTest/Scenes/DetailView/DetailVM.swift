//
//  DetailVM.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation

class DetailVM: ViewModel {
   
    typealias Factory = APIServiceFactory
    private let apiService: APIService
    private let item: SearchItem
    
    init(item: SearchItem, factory: Factory = DefaultFactory()) {
        self.apiService = factory.makeAPIService()
        self.item = item
    }
    
    func url() -> URL? {
        guard let homepage = self.item.htmlUrl, let url = URL(string: homepage) else { return nil }
        return url
    }
    
    func titleText() -> String? {
        return self.item.name
    }
        
}
