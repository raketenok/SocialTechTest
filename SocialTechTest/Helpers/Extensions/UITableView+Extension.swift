//
//  UITableViewCell+Extension.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        let identifier = String(describing: type.self)
        let nib =  UINib.init(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: type.self), for: indexPath) as! T
    }
}
