//
//  SearchKeywordHistoryCell.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2019/01/10.
//  Copyright © 2019 hicka04. All rights reserved.
//

import UIKit

protocol SearchKeywordHistoryCellDelegate: AnyObject {
    
    func didPushButton(keyword: String)
}

class SearchKeywordHistoryCell: UITableViewCell {

    @IBOutlet private weak var historyLabel: UILabel!
    @IBAction private func historySetButton() {
        delegate?.didPushButton(keyword: keyword)
    }
    
    private var keyword: String = "" {
        didSet {
            historyLabel.text = keyword
        }
    }
    
    weak var delegate: SearchKeywordHistoryCellDelegate?
    
    func setKeyword(_ keyword: String) {
        self.keyword = keyword
    }
}
