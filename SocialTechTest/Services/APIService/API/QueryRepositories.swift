//
//  APIOperation.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 31.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation

//MARK: Impl
final class QueryRepositories {
    
    func searchRepositories(query: String, token: String?, page: Int, perPage: Int, sort: Sort, order: Order, completion: @escaping APISearchCompletion) {
        let group = DispatchGroup()
        var queryRepositoriesError: Error?
        var firstResponse: [SearchItem]?
        var secondResponse: [SearchItem]?
        
        group.enter()
        SearchRequest().searchRepositories(query: query, token: token, page: page, perPage: perPage, sort: sort, order: order) { (response, error) in
            firstResponse = response
            queryRepositoriesError = error
            group.leave()
        }
        
        group.enter()
        SearchRequest().searchRepositories(query: query, token: token, page: page + 1, perPage: perPage, sort: sort, order: order) { (response, error) in
            secondResponse = response
            queryRepositoriesError = error
            group.leave()
        }
        
        group.notify(queue: .main) {
            var items: [SearchItem] = []
            if let firstResponseItems = firstResponse, let secondResponseItems = secondResponse {
                let firstElementFirstResponseStartsCount = firstResponseItems.first?.stargazersCount ?? 0
                let firstElementSecondResponseStartsCount = secondResponseItems.first?.stargazersCount ?? 0
                if firstElementFirstResponseStartsCount > firstElementSecondResponseStartsCount {
                    items = firstResponseItems + secondResponseItems
                } else {
                    items = secondResponseItems + firstResponseItems
                }
            }
            completion(items, queryRepositoriesError)
        }
    }
}


//MARK: Code below is example. Can use it for implementation with OperationQueue
// For serial OperationQueue or for OperationQueue with Operation's dependencies use APIOperationRequest directly

final private class APIOperationRequest: AsyncOperation {
    
    private let text: String
    private let page: Int
    private let token: String?
    private let perPage: Int
    private var result: APISearchCompletion?
    private var urlSesstionTask: URLSessionTask?
    
    init(query: String, page: Int, perPage: Int, token: String?, completion: @escaping APISearchCompletion) {
        self.text = query
        self.page = page
        self.perPage = perPage
        self.token = token
        self.result = completion
        super.init()
    }
    
    override func main() {
        
        guard !self.cancelRequestIfNeed() else { return }
        SearchRequest().searchRepositories(query: self.text, token: self.token, page: self.page, perPage: self.perPage, sort: .stars, order: .desc) { [weak self] (response, err) in
            guard let self = self else { return }
            guard !self.cancelRequestIfNeed() else { return }
            self.result?(response, err)
            self.state = .finished
        }
    }
    
     private func cancelRequestIfNeed() -> Bool {
        if isCancelled  {
            self.result = nil
            return true
        }
        return false
    }
    
    override func cancel() {
        super.cancel()
        self.urlSesstionTask?.cancel()
        self.result = nil
    }
}

private class AsyncOperation: Operation {
    
    enum State: String {
        case ready, executing, finished
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && self.state == .ready
    }
    
    override var isExecuting: Bool {
        return self.state == .executing
    }
    
    override var isFinished: Bool {
        return self.state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            self.state = .finished
            return
        }
        main()
        self.state = .executing
    }
    
    override func cancel() {
        super.cancel()
        self.state = .finished
    }
}
