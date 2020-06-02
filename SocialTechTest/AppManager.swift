//
//  AppManager.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import UIKit

protocol AppService: class { }

class AppManager {
   
    static let shared = AppManager()
    private var services: [AppService] = []
    private init() { }
    
    func configure(window: UIWindow) {
        self.services.append(LocalSettingsServiceImp())
        self.services.append(APIServiceImp())
        self.services.append(CoordinatorService(window: window))
    }
    
    var apiService: APIService {
        return self.services.first { $0 as? APIService != nil } as! APIService
    }
    
    var localSettingsService: LocalSettingsService {
        return self.services.first { $0 as? LocalSettingsService != nil } as! LocalSettingsService
    }
    
    var coordinatorService: CoordinatorService {
         return self.services.first { $0 as? CoordinatorService != nil } as! CoordinatorService
    }
    
}
