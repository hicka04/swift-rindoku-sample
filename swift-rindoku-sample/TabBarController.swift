//
//  TabBarController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2019/01/21.
//  Copyright © 2019 hicka04. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchResult = UINavigationController(rootViewController: SearchResultListViewController())
        searchResult.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        let bookmark = UINavigationController(rootViewController: BookmarkListViewController())
        bookmark.tabBarItem = UITabBarItem(title: "bookmarks", image: #imageLiteral(resourceName: "bookmarks"), tag: 1)
        viewControllers = [
            searchResult,
            bookmark
        ]
    }
}
