//
//  BookmarkListViewController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2019/01/21.
//  Copyright © 2019 hicka04. All rights reserved.
//

import UIKit
import RealmSwift

class BookmarkListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "cell")
            
            notificationToken = bookmarks.observe { [weak self] change in
                guard let tableView = self?.tableView else { return }
                switch change {
                case .initial:
                    tableView.reloadData()
                    tableView.flashScrollIndicators()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.beginUpdates()
                    tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                         with: .automatic)
                    tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) },
                                         with: .automatic)
                    tableView.endUpdates()
                case .error:
                    break
                }
            }
        }
    }
    
    private var notificationToken: NotificationToken?
    
    private let realm = try! Realm()
    private var bookmarks: Results<Bookmark> {
        return realm.objects(Bookmark.self).sorted(byKeyPath: sort.rawValue, ascending: sort.isAscending)
    }
    
    private var sort: Sort = .bookmarkedAt {
        didSet {
            tableView.reloadData()
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: sort.title, style: .plain, target: self, action: #selector(sortButtonDidTap))
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "bookmarks"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: sort.title, style: .plain, target: self, action: #selector(sortButtonDidTap))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    @objc private func sortButtonDidTap() {
        let actionSheet = UIAlertController(title: "ソート", message: nil, preferredStyle: .actionSheet)
        Sort.allCases.forEach { sort in
            let action = UIAlertAction(title: sort.title, style: .default) { _ in
                self.sort = sort
            }
            if self.sort == sort {
                action.setValue(true, forKey: "checked")
            }
            actionSheet.addAction(action)
        }
        actionSheet.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension BookmarkListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RepositoryCell
        cell.set(repository: bookmarks[indexPath.row].repository, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = bookmarks[indexPath.row].repository!
        let detailView = RepositoryDetailViewController(repository: repository)
        detailView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailView, animated: true)
    }
}

extension BookmarkListViewController {
    
    enum Sort: String, CaseIterable {
        case bookmarkedAt
        case repositoryName = "repository.fullName"
        
        var title: String {
            switch self {
            case .bookmarkedAt:   return "追加順"
            case .repositoryName: return "リポジトリ名順"
            }
        }
        
        var isAscending: Bool {
            switch self {
            case .bookmarkedAt:   return false
            case .repositoryName: return true
            }
        }
    }
}

extension BookmarkListViewController: RepositoryCellDelegate {
    
    func repositoryCell(_ cell: RepositoryCell, didTapBookmarkButtonFrom repository: Repository) {
        // ブックマーク一覧では削除のみを想定
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
