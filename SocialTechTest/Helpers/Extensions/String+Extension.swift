//
//  String+Extension.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation


extension String: Error {
    
    
    func makeError() -> Error {
        return NSError(domain: self, code: 6666, userInfo: nil)
    }
}


