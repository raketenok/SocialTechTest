//
//  ViewControllerBase.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import  UIKit


class ViewControllerBase<T: ViewModel>: UIViewController {
    var viewModel: T!
    
    override func viewDidLoad() {
        
        self.viewModel.baseVew = self
    }
    
}

extension ViewControllerBase {
    class func instantiateFromStoryboard(viewModel: T) -> Self {
        guard let viewController = UIViewController.instantiateFromStoryboard(type: self) else {
            fatalError()
        }
        viewController.viewModel = viewModel
        return viewController
    }
}

class ViewModel {
    weak var baseVew: UIViewController?
    
}
