//
//  TabBarController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2019/01/21.
//  Copyright © 2019 hicka04. All rights reserved.
//

import UIKit
import RealmSwift

class TabBarController: UITabBarController {
    
    private var bookmarkUpdateToken: NotificationToken?
    private var badgeCount: Int = 0 {
        didSet {
            guard badgeCount > 0 else {
                bookmark.tabBarItem.badgeValue = nil
                badgeCount = 0
                return
            }
            
            bookmark.tabBarItem.badgeValue = "\(badgeCount)"
        }
    }
    
    let searchResult: UIViewController = {
        let searchResult = UINavigationController(rootViewController: SearchResultListViewController())
        searchResult.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return searchResult
    }()
    
    let bookmark: UIViewController = {
        let bookmark = UINavigationController(rootViewController: BookmarkListViewController())
        bookmark.tabBarItem = UITabBarItem(title: "bookmarks", image: #imageLiteral(resourceName: "bookmarks"), tag: 1)
        return bookmark
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            searchResult,
            bookmark
        ]
        
        bookmarkUpdateToken = try! Realm().objects(Bookmark.self).observe({ [weak self] change in
            guard let `self` = self else { return }
            
            switch change {
            case .update(_, let deletions, let insertions, _):
                self.badgeCount += insertions.count - deletions.count
            default:
                break
            }
        })
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard item == bookmark.tabBarItem else {
            return
        }
        
        badgeCount = 0
    }
}
