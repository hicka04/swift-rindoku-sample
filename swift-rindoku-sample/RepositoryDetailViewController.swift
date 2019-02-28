//
//  DetailViewController.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/09/27.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

class RepositoryDetailViewController: UIViewController {
    
    // iOS10未満を対応しているアプリで
    // WKWebViewをXibで配置するとクラッシュするので注意(バグです)
    @IBOutlet private weak var webView: WKWebView!
    
    private let realm = try! Realm()
    
    private let repository: Repository
    
    private var isBookmarked: Bool {
        return realm.objects(Bookmark.self).contains(where: { bookmark -> Bool in
            bookmark.repository.id == repository.id
        })
    }
    
    private var notificationToken: NotificationToken?
    
    init(repository: Repository) {
        self.repository = repository
        
        super.init(nibName: nil, bundle: nil)
        
        
        notificationToken = realm.objects(Bookmark.self)
            .filter("repository.id = %d", repository.id)
            .observe { [weak self] change in
                guard let `self` = self else { return }

                switch change {
                case .initial, .update:
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.isBookmarked ? #imageLiteral(resourceName: "bookmark") : #imageLiteral(resourceName: "bookmark_border"),
                                                                             style: .plain,
                                                                             target: self,
                                                                             action: #selector(self.bookmarkButtonDidTap))
                default:
                    break
                }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = repository.fullName

        let url = URL(string: repository.htmlUrl)!
        webView.load(URLRequest(url: url))
    }
    
    @objc private func bookmarkButtonDidTap() {
        if isBookmarked {
            realm.objects(Bookmark.self)
                .filter { bookmark -> Bool in
                    bookmark.repository.id == self.repository.id
                }.forEach { bookmark in
                    try! realm.write {
                        realm.delete(bookmark)
                    }
                }
        } else {
            guard realm.objects(Bookmark.self).count < 50 else {
                present(UIAlertController.createBookmarkLimitAlert(), animated: true, completion: nil)
                return
            }
            
            try! realm.write {
                realm.add(Bookmark(repository: repository))
            }
        }
    }
}
