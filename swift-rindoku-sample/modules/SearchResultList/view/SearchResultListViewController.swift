//
//  SearchResultListViewController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2018/08/11.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit
import RealmSwift

protocol SearchResultListView: AnyObject {
    
    func updateLatestSearchKeyword(_ keyword: String)
    func updateRepositories(_ repositories: [Repository])
}

class SearchResultListViewController: UIViewController {
    
    var presenter: SearchResultListPresentation!
    
    @IBOutlet private weak var tableView: UITableView!
    private lazy var searchController: UISearchController = {
        let resultsController = SearchKeywordHistoryListViewController()
        resultsController.delegate = self
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        searchController.searchBar.placeholder = "キーワードを入力"
        searchController.searchBar.delegate = self
        searchController.delegate = self
        return searchController
    }()
    
    private let cellId = "cellId"
    
    let realm = try! Realm()
    
    // 配列を定義してこれを元にtableViewに表示
    // APIクライアントを作ったらそのデータに差し替え
    private var repositories: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                self.tableView.flashScrollIndicators()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        
        definesPresentationContext = true
        
        // tableViewのカスタマイズをするためにdelegateとdataSourceを設定
        // 今回は自身をUITableViewDelegateとUITableViewDataSourceに準拠させて使う
        tableView.delegate = self
        tableView.dataSource = self
        
        // tableViewで使うセルを登録しておく
        // 登録しておくとcellForRowAtでdequeueReusableCellから取得できるようになる
        // セルの使い回しができる
        // CellReuseIdentifierは使い回し時にも使うのでプロパティに切り出すのがおすすめ
        // Xibで作ったセルを登録するときはUINib(nibBName:bundle:)を使う必要がある
        let nib = UINib(nibName: "RepositoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 画面が表示され始めたタイミングで
        // tableViewで選択中のセルがあれば非選択状態にする
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SearchResultListViewController: SearchResultListView {
    
    func updateLatestSearchKeyword(_ keyword: String) {
        guard searchController.searchBar.text?.isEmpty ?? true else {
            return
        }
        
        searchController.searchBar.text = keyword
    }
    
    func updateRepositories(_ repositories: [Repository]) {
        self.repositories = repositories
    }
}

// UITableViewDelegateとUITableViewDataSourceに準拠
// extensionに切り出すと可読性が上がる
extension SearchResultListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 配列の要素数を返す
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // viewDidLoadで登録しておいたセルを取得
        // カスタムセルを取り出すときはキャストが必要(強制案ラップでOK)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepositoryCell
        cell.set(repository: repositories[indexPath.row], delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セル選択後に呼ばれる
        // 押されたセルの場所(indexPath)などに応じて処理を変えることができるが
        // 今回は必ずDetailViewControllerに遷移するように実装
        presenter.didSelectRow(at: indexPath)
    }
}

extension SearchResultListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        defer {
            searchController.dismiss(animated: true, completion: nil)
        }
        guard let searchBarText = searchBar.text,
            !searchBarText.isEmpty else {
            return
        }
        
        tableView.setContentOffset(.zero, animated: true)
        
        presenter.searchBarSearchButtonClicked(searchKeyword: searchBarText)
    }
}

extension SearchResultListViewController: UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        presenter.didDismissSearchController()
    }
}

extension SearchResultListViewController: SearchResultsControllerDelegate {
    
    func resultsController(_ resultsController: UIViewController,
                           didUpdateKeyword keyword: String,
                           shouldSearch: Bool) {
        searchController.searchBar.text = keyword
        if shouldSearch {
            searchController.dismiss(animated: true, completion: nil)
            tableView.setContentOffset(.zero, animated: true)
            presenter.resultsControllerDidUpdateKeyword(keyword)
        }
    }
}

extension SearchResultListViewController: RepositoryCellDelegate {
    
    func repositoryCell(_ cell: RepositoryCell, didTapBookmarkButtonFrom repository: Repository) {
        if realm.objects(Bookmark.self).contains(where: { bookmark in bookmark.repository.id == repository.id }) {
            realm.objects(Bookmark.self)
                .filter { bookmark -> Bool in
                    bookmark.repository.id == repository.id
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
