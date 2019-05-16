//
//  SearchResultListPresenter.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2019/04/11.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation

protocol SearchResultListPresentation: AnyObject {
    
    func viewDidLoad()
    func didSelectRow(at indexPath: IndexPath)
    func searchBarSearchButtonClicked(searchKeyword: String)
    func resultsControllerDidUpdateKeyword(_ keyword: String)
    func bookmarkButtonTapped(repository: Repository)
}

final class SearchResultListPresenter {
    
    private weak var view: SearchResultListView?
    private let router: SearchResultListWireframe
    private let repositoryInteractor: GitHubRepositoryUsecase
    private let historyInteractor: SearchHistoryUsecase
    private let bookmarkInteractor: BookmarkUsecase
    
    private var searchKeyword: String? {
        didSet {
            guard let keyword = searchKeyword else { return }
            
            view?.updateLatestSearchKeyword(keyword)
            
            repositoryInteractor.search(from: keyword) { [weak self] result in
                switch result {
                case .success(let repositories):
                    self?.repositories = repositories
                case .failure:
                    // viewにエラーを伝える
                    break
                }
            }
            
            try? historyInteractor.save(keyword: keyword)
        }
    }
    
    private var repositories: [Repository] = [] {
        didSet {
            // TODO: viewに結果伝える
        }
    }
    
    init(view: SearchResultListView,
         router: SearchResultListWireframe,
         repositoryInteractor: GitHubRepositoryUsecase,
         historyInteractor: SearchHistoryUsecase,
         bookmarkInteractor: BookmarkUsecase) {
        self.view = view
        self.router = router
        self.repositoryInteractor = repositoryInteractor
        self.historyInteractor = historyInteractor
        self.bookmarkInteractor = bookmarkInteractor
    }
}

extension SearchResultListPresenter: SearchResultListPresentation {
    
    func viewDidLoad() {
        historyInteractor.loadLatestSearchHistory {
            searchKeyword = $0?.keyword
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        // TODO: routerに伝える
    }
    
    func searchBarSearchButtonClicked(searchKeyword: String) {
        self.searchKeyword = searchKeyword
    }
    
    func resultsControllerDidUpdateKeyword(_ keyword: String) {
        searchKeyword = keyword
    }
    
    func bookmarkButtonTapped(repository: Repository) {
        bookmarkInteractor.add(repository: repository) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                // TODO: viewに伝える
                print(error)
            }
        }
    }
}
