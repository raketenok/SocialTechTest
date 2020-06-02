//
//  RecentVC.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import UIKit

class RecentVC: ViewControllerBase<RecentVM> {
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        self.tableView.isHidden = self.viewModel.count() == 0
        self.tableView.registerCell(RepositoryCell.self)
        self.viewModel.reloadViewCallback = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension RecentVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.showDetail(index: indexPath.row)
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(RepositoryCell.self, indexPath: indexPath)
        
        cell.configure(item: self.viewModel.itemAt(index: indexPath.row))
        return cell
    }
}


