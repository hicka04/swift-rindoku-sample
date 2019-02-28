//
//  Bookmark.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2019/01/21.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

class Bookmark: Object {
    
    @objc dynamic private(set) var repository: Repository!
    @objc dynamic private var bookmarkedAt: Date = .init()
    
    convenience init(repository: Repository) {
        self.init()
        self.repository = repository
    }
}
