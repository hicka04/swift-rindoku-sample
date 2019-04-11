//
//  BookmarkInteractor.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2019/04/04.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

protocol BookmarkUsecase: AnyObject {
    
    func add(repository: Repository, completion: (Result<Repository, BookmarkAddError>) -> Void)
    func delete(repository: Repository)
}

final class BookmarkInteractor {
    
    private let bookmarkLimit = 50
    
    private let realm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
}

extension BookmarkInteractor: BookmarkUsecase {
    
    func add(repository: Repository, completion: (Result<Repository, BookmarkAddError>) -> Void) {
        guard realm.objects(Bookmark.self).count < bookmarkLimit else {
            completion(.failure(.upperLimit))
            return
        }
        
        do {
            defer {
                completion(.success(repository))
            }
            try realm.write {
                realm.add(Bookmark(repository: repository))
            }
        } catch {
            completion(.failure(.unexpected(error)))
        }
    }
    
    func delete(repository: Repository) {
        realm.objects(Bookmark.self)
            .filter { bookmark -> Bool in
                bookmark.repository.id == repository.id
            }.forEach { bookmark in
                try! realm.write {
                    realm.delete(bookmark)
                }
            }
    }
}

enum BookmarkAddError: Error {
    case upperLimit
    case unexpected(Error)
}
