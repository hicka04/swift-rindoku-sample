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
    
    private var bookmarks: Results<Bookmark> {
        let realm = try! Realm()
        return realm.objects(Bookmark.self).sorted(byKeyPath: "bookmarkedAt", ascending: false)
    }
    
    deinit {
        notificationToken?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "bookmarks"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
        cell.set(repository: bookmarks[indexPath.row].repository)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = bookmarks[indexPath.row].repository!
        let detailView = RepositoryDetailViewController(repository: repository)
        detailView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailView, animated: true)
    }
}
