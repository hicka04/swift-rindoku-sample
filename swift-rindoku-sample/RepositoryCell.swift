//
//  RepositoryCell.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/10/04.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    // カスタムViewの中に置いているSubViewはprivateにするのがおすすめ
    // 外から触れるとどこで見た目の変化を行っているのかの影響範囲が広くなってしまうため
    @IBOutlet private weak var label: UILabel!
    
    func set(repositoryName name: String) {
        label.text = name
    }
}
