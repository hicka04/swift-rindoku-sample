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
    
    private let realm = try! Realm()
    private var notificationToken: NotificationToken?
    
    private var repository: Repository? {
        didSet {
            guard let repository = repository else { return }
            
            repositoryNameLabel.text = repository.fullName
            notificationToken = realm.objects(Bookmark.self)
                .filter("id = %d", repository.id.rawValue)
                .observe { [weak self] change in
                    switch change {
                    case .update:
                        self?.updateBookmarkButtonImage()
                    default:
                        break
                    }
                }
            
            updateBookmarkButtonImage()
        }
    }
    
    private var isBookmarked: Bool {
        return realm.objects(Bookmark.self).contains(where: { bookmark -> Bool in
            bookmark.repository == repository
        })
    }
    
    @IBAction private func bookmarkButtonDidTap() {
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
    }
    
    func set(repository: Repository) {
        self.repository = repository
    }
    
    private func updateBookmarkButtonImage() {
        bookmarkButton.setImage(isBookmarked ? #imageLiteral(resourceName: "bookmark"): #imageLiteral(resourceName: "bookmark_border"), for: .normal)
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
