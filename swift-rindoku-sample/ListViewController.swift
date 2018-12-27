//
//  ViewController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2018/08/11.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit
import RealmSwift

class ListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "キーワードを入力"
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private let cellId = "cellId"
    
    private var keyword = "" {
        didSet {
            let request = GitHubAPI.SearchRepositories(keyword: keyword)
            GitHubClient().send(request: request) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.data = value.items
                case .failure(let error):
                    let alert = UIAlertController.createGitHubErrorAlert(from: error)
                    DispatchQueue.main.async {
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
            if searchController.searchBar.text?.isEmpty ?? true {
                searchController.searchBar.text = keyword
            }
            
            let history = SearchKeywordHistory()
            history.keyword = keyword
            try! realm.write {
                realm.add(history)
            }
        }
    }
    
    let realm = try! Realm()
    
    // 配列を定義してこれを元にtableViewに表示
    // APIクライアントを作ったらそのデータに差し替え
    var data: [Repository] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        
        if let last = realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "lastSearchAt").last {
            keyword = last.keyword
        }
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

// UITableViewDelegateとUITableViewDataSourceに準拠
// extensionに切り出すと可読性が上がる
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 配列の要素数を返す
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // viewDidLoadで登録しておいたセルを取得
        // カスタムセルを取り出すときはキャストが必要(強制案ラップでOK)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepositoryCell
        cell.set(repositoryName: data[indexPath.row].fullName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セル選択後に呼ばれる
        // 押されたセルの場所(indexPath)などに応じて処理を変えることができるが
        // 今回は必ずDetailViewControllerに遷移するように実装
        let repository = data[indexPath.row]
        let detailView = DetailViewController(repository: repository)
        
        // navigationController:画面遷移を司るクラス
        // pushViewController(_:animated:)で画面遷移できる
        navigationController?.pushViewController(detailView, animated: true)
    }
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        defer {
            searchController.dismiss(animated: true, completion: nil)
        }
        guard let searchBarText = searchBar.text,
            !searchBarText.isEmpty else {
            return
        }
        
        keyword = searchBarText
        
        tableView.setContentOffset(.zero, animated: true)
    }
}
