//
//  SearchKeywordHistoryEntity.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/11/29.
//  Copyright © 2018 hicka04. All rights reserved.
//

import Foundation

struct SearchKeywordHistoryEntity: Codable {
    
    let keyword: String
    let lastSearchAt: Date
}
