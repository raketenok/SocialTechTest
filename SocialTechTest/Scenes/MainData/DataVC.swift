//
//  DataVC.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import Foundation
import UIKit

class DataVC: ViewControllerBase<DataVM> {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var recentButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
        self.loadingLabel.isHidden = true
        self.tableView.registerCell(RepositoryCell.self)
        self.viewModel.reloadViewCallback = { [weak self] in
            self?.tableView.reloadData()
            self?.tableView.isHidden = self?.viewModel.count() == 0
        }
        self.viewModel.isLoading = { [weak self] isLoading in
            let alpha: CGFloat = isLoading ? 1.0 : 0.0
            UIView.animate(withDuration: 0.3) {
                self?.loadingLabel.isHidden = false
                self?.loadingLabel.alpha = alpha
            }
        }
    }
    
    @IBAction private func recentAction(_ sender: UIBarButtonItem) {
        self.viewModel.showRecent()
    }
}

extension DataVC: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.numberOfRows(inSection: indexPath.section) - indexPath.row == 2 {
            self.viewModel.loadNextQuery(text: searchBar.text ?? "")
        }
    }
    
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

extension DataVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       self.viewModel.findRepo(text: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

