//
//  DetailVC.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import UIKit

class DetailVC: MapView<DetailVM> {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.titleText()
        guard let url = self.viewModel.url() else { return }
        self.webView.load(URLRequest(url: url))
       // self.addCloseButton()
    }
}
