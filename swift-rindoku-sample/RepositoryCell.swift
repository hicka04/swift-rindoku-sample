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
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    
    private var isBookmarked: Bool = false {
        didSet {
            bookmarkButton.setImage(isBookmarked ? #imageLiteral(resourceName: "bookmark") : #imageLiteral(resourceName: "bookmark_border"), for: .normal)
        }
    }
    
    @IBAction private func bookmarkButtonDidTap() {
        isBookmarked.toggle()
    }
    
    func set(repositoryName name: String) {
        repositoryNameLabel.text = name
    }
}
