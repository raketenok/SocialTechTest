//
//  DefaultFactory.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation


struct DefaultFactory { }

//Services
extension DefaultFactory: APIServiceFactory { }
extension DefaultFactory: LocalSettingServiceFactory { }
//Coordinators
extension DefaultFactory: AppCoordinatorServiceFactory { }
