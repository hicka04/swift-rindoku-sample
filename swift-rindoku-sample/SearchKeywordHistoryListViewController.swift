//
//  SearchKeywordHistoryListViewController.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2019/01/10.
//  Copyright © 2019 hicka04. All rights reserved.
//

import UIKit
import RealmSwift

protocol SearchResultsControllerDelegate: AnyObject {
    
    func resultsController(_ resultsController: UIViewController,
                           didUpdateKeyword keyword: String,
                           shouldSearch: Bool)
}

class SearchKeywordHistoryListViewController: UITableViewController {
    
    weak var delegate: SearchResultsControllerDelegate?

    private var inputKeyword: String = "" {
        didSet {
            let realm = try! Realm()
            keywordHistories = realm.objects(SearchKeywordHistory.self)
                .sorted(byKeyPath: "lastSearchAt", ascending: false)
                .filter { $0.keyword.contains(self.inputKeyword) }
                .map { $0.keyword }
        }
    }
    
    private var keywordHistories: [String] = [] {
        didSet {
            guard keywordHistories != oldValue else { return }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "SearchKeywordHistoryCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
}

extension SearchKeywordHistoryListViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywordHistories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchKeywordHistoryCell
        cell.setKeyword(keywordHistories[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyword = keywordHistories[indexPath.row]
        delegate?.resultsController(self, didUpdateKeyword: keyword, shouldSearch: true)
    }
}

extension SearchKeywordHistoryListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputKeyword = searchController.searchBar.text else { return }
        
        self.inputKeyword = inputKeyword
    }
}

extension SearchKeywordHistoryListViewController: SearchKeywordHistoryCellDelegate {
    
    func didPushButton(keyword: String) {
        delegate?.resultsController(self,
                                    didUpdateKeyword: keyword, shouldSearch: false)
    }
}
