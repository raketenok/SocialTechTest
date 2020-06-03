//
//  AppCoordinator.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: CoordinatorBase {
   
    typealias Factory = DefaultFactory
    private let window: UIWindow!
    private var rootViewController: UIViewController?
    
    init(window: UIWindow, factory: Factory = DefaultFactory()) {
        self.window = window
    }
    
    func start() {
        self.showMainVC()
    }
    
    func finish() { }
    
    private func showMainVC() {
        let vm = MainVM(delegate: self)
        let initialViewController = MainVC.instantiateFromStoryboard(viewModel: vm)
        let navigation = UINavigationController(rootViewController: initialViewController)
        navigation.setNavigationBarHidden(true, animated: false)
        self.setRootVC(viewController: navigation)
    }
    
    private func showDataVC() {
        let vm = DataVM(delegate: self)
        let initialViewController = DataVC.instantiateFromStoryboard(viewModel: vm)
        let nav = UINavigationController(rootViewController: initialViewController)
        self.setRootVC(viewController: nav)
    }
    
    private func setRootVC(viewController: UIViewController) {
        self.rootViewController = viewController
        self.window.rootViewController = viewController
        self.window.makeKeyAndVisible()
    }
    
    func showRecentVC() {
        let vm = RecentVM(delegate: self)
        let vc = RecentVC.instantiateFromStoryboard(viewModel: vm)
        self.rootViewController?.show(vc, sender: nil)
    }
    
    func showDetailVC(item: SearchItem) {
        let vm = DetailVM(item: item)
        let vc = DetailVC.instantiateFromStoryboard(viewModel: vm)
        self.rootViewController?.show(vc, sender: nil)
        //Use code below for modal presenting:
        // let nav = UINavigationController(rootViewController: vc)
        // self.rootViewController?.present(nav, animated: true, completion: nil)
    }
}


extension AppCoordinator: MainVMDelegate {
    func successLogin() {
        self.showDataVC()
    }
}

extension AppCoordinator: DataVMDelegate {
    func showRecent() {
        self.showRecentVC()
    }
    
    func showDetail(item: SearchItem) {
        self.showDetailVC(item: item)
    }
}

extension AppCoordinator: RecentVMDelegate {
    
    func showDetailRecent(item: SearchItem) {
        self.showDetailVC(item: item)
    }
}
