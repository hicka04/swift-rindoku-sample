//
//  SearchHistoryInteractor.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2019/03/28.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

protocol SearchHistoryUsecase: AnyObject {
    
    func save(keyword: String) throws
    func loadLatestSearchHistory(completion: (SearchKeywordHistory?) -> Void)
}

final class SearchHistoryInteractor {
    
    let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
}

extension SearchHistoryInteractor: SearchHistoryUsecase {
    
    func save(keyword: String) throws {
        if let sameKeywordHistory = realm.objects(SearchKeywordHistory.self).first(where: { $0.keyword == keyword }) {
            try! realm.write {
                sameKeywordHistory.lastSearchAt = Date()
            }
        } else {
            let max = 50
            if realm.objects(SearchKeywordHistory.self).count >= max {
                realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "lastSearchAt").enumerated().forEach { (offset, history) in
                    guard offset >= max - 1 else {
                        return
                    }
                    try! realm.write {
                        realm.delete(history)
                    }
                }
            }
            let history = SearchKeywordHistory()
            history.keyword = keyword
            try! realm.write {
                realm.add(history)
            }
        }
    }
    
    func loadLatestSearchHistory(completion: (SearchKeywordHistory?) -> Void) {
        completion(realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "lastSearchAt").last)
    }
}
