//
//  RepositoryCell.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/10/04.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet private weak var label: UILabel!
    
    func set(repositoryName name: String) {
        label.text = name
    }
}
