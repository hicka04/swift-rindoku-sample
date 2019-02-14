//
//  RepositoryCell.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/10/04.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit
import RealmSwift

protocol RepositoryCellDelegate: AnyObject {
    
    func repositoryCell(_ cell: RepositoryCell, didTapBookmarkButtonFrom repository: Repository)
}

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
            
            let bookmarks = realm.objects(Bookmark.self)
                                .filter("repository.id = %d", repository.id)
            let setBookmarkImage = { (bookmarks: Results<Bookmark>) in
                self.bookmarkButton.setImage(bookmarks.isEmpty ? #imageLiteral(resourceName: "bookmark_border"): #imageLiteral(resourceName: "bookmark"), for: .normal)
            }
            notificationToken = bookmarks.observe { change in
                switch change {
                case .update(let bookmarks, _, _, _):
                    setBookmarkImage(bookmarks)
                default:
                    break
                }
            }
            
            setBookmarkImage(bookmarks)
        }
    }
    
    private weak var delegate: RepositoryCellDelegate?
    
    @IBAction private func bookmarkButtonDidTap() {
        delegate?.repositoryCell(self, didTapBookmarkButtonFrom: repository!)
    }
    
    func set(repository: Repository, delegate: RepositoryCellDelegate) {
        self.repository = repository
        self.delegate = delegate
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}
