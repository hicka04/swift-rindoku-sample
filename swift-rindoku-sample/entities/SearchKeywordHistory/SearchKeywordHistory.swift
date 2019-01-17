//
//  SearchKeywordHistory.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/12/13.
//  Copyright © 2018 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

class SearchKeywordHistory: Object {
    
    @objc dynamic var keyword: String = ""
    @objc dynamic var lastSearchAt: Date = .init()
}
