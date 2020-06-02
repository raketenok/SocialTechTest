//
//  DataVM.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation

protocol DataVMDelegate: class {
    func showRecent()
    func showDetail(item: SearchItem)
}

class DataVM: ViewModel {
    
    typealias Factory = APIServiceFactory & LocalSettingServiceFactory
    private let apiService: APIService
    private var localSettingsService: LocalSettingsService
    
    private weak var delegate: DataVMDelegate?
    private var items: [SearchItem] = []
    private var timer = Timer()
    private var currentQueryPage: Int = 1
    var reloadViewCallback: (()->Void)?
    var isLoading: ((Bool)->Void)?

    
    init(delegate: DataVMDelegate?, factory: Factory = DefaultFactory()) {
        self.apiService = factory.makeAPIService()
        self.localSettingsService = factory.makeLocalSettingsService()
        self.delegate = delegate
    }
    
    func count() -> Int {
        return self.items.count
    }
    
    func itemAt(index: Int) -> SearchItem? {
        guard self.items.count > index else { return nil }
        return self.items[index]
    }
    
    func loadNextQuery(text: String) {
        guard self.count() >= 30 else { return }
        
        currentQueryPage += 2
        self.isLoading?(true)
        self.apiService.searchRepositories(query: text, page: self.currentQueryPage, perPage: 15, sort: .stars, order: .desc, completion: { [weak self] (result, err) in
            guard let self = self else { return }
            self.isLoading?(false)

            if let error = err {
                self.baseVew?.errorAlert(error)
                return
            }
            if let items = result {
                self.items.append(contentsOf: items)
            }
            DispatchQueue.main.async {
                self.reloadViewCallback?()
            }
            return
        })
    }
    
    func findRepo(text: String) {
        self.timer.invalidate()
        
        guard text.count > 1 else {
            self.items = []
            self.reloadViewCallback?()
            return
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.isLoading?(true)

            self.apiService.searchRepositories(query: text, page: self.currentQueryPage, perPage: 15, sort: .stars, order: .desc, completion: { [weak self] (result, err) in
                guard let self = self else { return }
                self.isLoading?(false)

                if let error = err {
                    self.baseVew?.errorAlert(error)
                    return
                }
                if let items = result {
                    self.items = items
                }
                DispatchQueue.main.async {
                    self.reloadViewCallback?()
                }
                return
            })
        }
    }
    
    func showDetail(index: Int) {
        guard self.items.count > index else { return }
        let item = self.items[index]
        self.localSettingsService.updateRecentItem(item: item)
        self.delegate?.showDetail(item: item)
    }
    
    func showRecent() {
        self.delegate?.showRecent()
    }
    
    
}
