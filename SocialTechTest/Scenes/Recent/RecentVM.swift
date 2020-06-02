//
//  RecentVM.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation

protocol RecentVMDelegate: class {
    func showDetailRecent(item: SearchItem)
}

class RecentVM: ViewModel {
   
    typealias Factory = LocalSettingServiceFactory
    private let localSettingsService: LocalSettingsService
    private weak var delegate: RecentVMDelegate?
    private var recentItems: [SearchItem]!
    var reloadViewCallback: (()->Void)?

    init(delegate: RecentVMDelegate?, factory: Factory = DefaultFactory()) {
        self.delegate = delegate
        self.localSettingsService = factory.makeLocalSettingsService()
        self.recentItems = self.localSettingsService.recentRepositories.reversed()
    }
    
    func count() -> Int {
        return self.recentItems.count
    }
    
    func itemAt(index: Int) -> SearchItem? {
        guard self.recentItems.count > index else { return nil }
        return self.recentItems[index]
    }
    
    func showDetail(index: Int) {
        guard self.recentItems.count > index else { return }
        let item = self.recentItems[index]
        self.localSettingsService.updateRecentItem(item: item)
        self.recentItems = self.localSettingsService.recentRepositories.reversed()
        self.delegate?.showDetailRecent(item: item)
        self.reloadViewCallback?()
    }
    
}
