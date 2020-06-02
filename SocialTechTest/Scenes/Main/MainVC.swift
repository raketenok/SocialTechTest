//
//  MainVC.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import UIKit
import WebKit


class MainVC: ViewControllerBase<MainVM> {
    
    @IBOutlet private weak var webView: WKWebView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = self.viewModel.buildURL(allowSignup: true)
        self.webView.navigationDelegate = self
        self.webView.load(URLRequest(url: url))
        
    }
}


extension MainVC: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.errorAlert(error)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.errorAlert(error)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let urlString = webView.url?.absoluteString else { return }
        guard let urlComponents = URLComponents(string: urlString) else { return }

        guard let host = urlComponents.host, let scheme = urlComponents.scheme else { return }

        let path = urlComponents.path
        let url = scheme + "://" + host + path
        guard let queryItem = urlComponents.queryItems?.first(where: { $0.name == "code" }) else { return }
        guard let code = queryItem.value else { return }
        self.viewModel.getAccessToken(url: url, code: code)
    }
}
