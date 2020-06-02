//
//  RepositoryCell.swift
//  SocialTechTest
//
//  Created by Ievgen Iefimenko on 30.05.2020.
//  Copyright © 2020 Ievgen Iefimenko. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
        
    func configure(item: SearchItem?) {
        guard let item = item else { return }
        self.titleLabel.text = item.fullName
        self.descriptionLabel.text = item.descriptionField
        guard let stars = item.stargazersCount else {
            self.starsLabel.text = nil
            return }
        self.starsLabel.text = "☆: \(stars)"
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
}
