//
//  MapView.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 03.06.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import WebKit

class MapView<T: ViewModel>: ViewControllerBase<T> {
    
    private(set) var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView = WKWebView(frame: self.view.bounds)
        self.view.addSubview(webView)
    }
}
