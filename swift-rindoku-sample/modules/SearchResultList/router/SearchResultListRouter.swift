//
//  SearchResultListRouter.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2019/04/25.
//  Copyright © 2019 hicka04. All rights reserved.
//

import UIKit

protocol SearchResultListWireframe: AnyObject {
    
}

final class SearchResultListRouter {
    
    private unowned let viewController: UIViewController
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func assembleModules() -> UIViewController {
        let view = SearchResultListViewController()
        let router = SearchResultListRouter(viewController: view)
        let repositoryInteractor = GitHubRepositoryInteractor()
        let historyInteractor = SearchHistoryInteractor()
        let bookmarkInteractor = BookmarkInteractor()
        let presenter = SearchResultListPresenter(view: view,
                                                  router: router,
                                                  repositoryInteractor: repositoryInteractor,
                                                  historyInteractor: historyInteractor,
                                                  bookmarkInteractor: bookmarkInteractor)
        
        view.presenter = presenter
        
        return view
    }
}

extension SearchResultListRouter: SearchResultListWireframe {
    
}
