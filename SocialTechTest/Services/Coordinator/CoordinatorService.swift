//
//  Coordinator.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import UIKit


protocol AppCoordinatorServiceFactory {
    func appCoordinatorService() -> CoordinatorService
}

extension AppCoordinatorServiceFactory {
    func appCoordinatorService() -> CoordinatorService {
        return AppManager.shared.coordinatorService
    }
}

final class CoordinatorService: AppService {
    
    typealias Factory = DefaultFactory
    private let coordinator: AppCoordinator
    
    init(window: UIWindow, factory: Factory = DefaultFactory()) {
        self.coordinator = AppCoordinator(window: window)
        self.coordinator.start()
    }
}



