//
//  SearchKeywordHistoryListViewController.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2019/01/10.
//  Copyright © 2019 hicka04. All rights reserved.
//

import UIKit
import RealmSwift

class SearchKeywordHistoryListViewController: UITableViewController {

    private var inputKeyword: String = "" {
        didSet {
            let realm = try! Realm()
            keywordHistories = realm.objects(SearchKeywordHistory.self).sorted(byKeyPath: "lastSearchAt", ascending: false)
                .filter { $0.keyword.contains(self.inputKeyword) }
                .map { $0.keyword }
        }
    }
    
    private var keywordHistories: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = keywordHistories[indexPath.row]
        return cell
    }
}

extension SearchKeywordHistoryListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputKeyword = searchController.searchBar.text else { return }
        
        self.inputKeyword = inputKeyword
    }
}
