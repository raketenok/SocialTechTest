//
//  UIViewController+Extension.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    static func instantiateFromStoryboard<T: UIViewController>(type: T.Type, storyboardName: String? = nil) -> T? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(identifier: "\(type)") as? T else {
            return nil
        }
        return viewController
    }
    
       
    func addCloseButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"),
                                                               style: .done,
                                                               target: self, action: #selector(didTapOnCloseButton(sender:)))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }
   
    @objc private func didTapOnCloseButton(sender button: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func errorAlert(_ error: Swift.Error, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""),
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel, handler: { _ in
            handler?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
