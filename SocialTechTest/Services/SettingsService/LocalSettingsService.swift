//
//  LocalSettingsService.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper


protocol LocalSettingServiceFactory {
    func makeLocalSettingsService() -> LocalSettingsService
}

extension LocalSettingServiceFactory {
    func makeLocalSettingsService() -> LocalSettingsService {
        return AppManager.shared.localSettingsService
    }
}

protocol LocalSettingsService: AppService {
    func updateRecentItem(item: SearchItem)
    var recentRepositories: [SearchItem] { get }
    var aceessToken: String? { get set }
}


class LocalSettingsServiceImp: LocalSettingsService {
    
    typealias Factory = DefaultFactory
    private let ud = UserDefaults.standard
    private let keyChainWrapper = KeychainWrapper.standard
    private static let kRecentItems = "RecentItems"
    private static let kToken = "AccessToken"
    private static let defaultMaxSizeOfRecentArray = 20
    
    init(factory: Factory = DefaultFactory()) {
   
    }
    
    var aceessToken: String? {
        get {
            return self.keyChainWrapper.string(forKey: LocalSettingsServiceImp.kToken)
        }
        set {
            self.keyChainWrapper.set(newValue ?? "", forKey: LocalSettingsServiceImp.kToken)
        }
    }

    
    func updateRecentItem(item: SearchItem) {
        self.recentRepositories.enumerated().forEach { (index, element) in
            if item == element, self.recentRepositories.count > index {
                self.recentRepositories.remove(at: index)
            }
        }
        self.recentRepositories.append(item)
    }
    
    var recentRepositories: [SearchItem] {
        get {
            guard let data = self.ud.value(forKey: LocalSettingsServiceImp.kRecentItems) as? Data else {
                return []
            }
            guard let values =  try? PropertyListDecoder().decode(Array<SearchItem>.self, from: data) else {
                return []
            }
            return values
        }
        set {
            if let archived = try? PropertyListEncoder().encode(newValue) {
                self.ud.set(archived, forKey: LocalSettingsServiceImp.kRecentItems)
                self.ud.synchronize()
                
                if self.recentRepositories.count > LocalSettingsServiceImp.defaultMaxSizeOfRecentArray {
                    self.recentRepositories.removeFirst()
                }
            }
        }
    }
    
}
