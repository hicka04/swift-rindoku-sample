//
//  RepositoryCell.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/10/04.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit
import RealmSwift

class RepositoryCell: UITableViewCell {

    // カスタムViewの中に置いているSubViewはprivateにするのがおすすめ
    // 外から触れるとどこで見た目の変化を行っているのかの影響範囲が広くなってしまうため
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    
    private var repository: Repository? {
        didSet {
            guard let repository = repository else { return }
            
            repositoryNameLabel.text = repository.fullName
            updateBookmarkButtonImage()
        }
    }
    
    private var isBookmarked: Bool {
        return try! Realm().objects(Bookmark.self).contains(where: { bookmark -> Bool in
            bookmark.repository == repository
        })
    }
    
    @IBAction private func bookmarkButtonDidTap() {
        let realm = try! Realm()
        if isBookmarked {
            realm.objects(Bookmark.self)
                .filter { bookmark -> Bool in
                    bookmark.repository == self.repository
                }.forEach { bookmark in
                    try! realm.write {
                        realm.delete(bookmark)
                    }
                }
        } else {
            try! realm.write {
                realm.add(Bookmark(repository: repository!))
            }
        }
        updateBookmarkButtonImage()
    }
    
    func set(repository: Repository) {
        self.repository = repository
    }
    
    private func updateBookmarkButtonImage() {
        bookmarkButton.setImage(isBookmarked ? #imageLiteral(resourceName: "bookmark"): #imageLiteral(resourceName: "bookmark_border"), for: .normal)
    }
}
