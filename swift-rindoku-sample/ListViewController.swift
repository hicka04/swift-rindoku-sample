//
//  ViewController.swift
//  swift-rindoku-sample
//
//  Created by hicka04 on 2018/08/11.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    let cellId = "cellId"
    let data = [
        "hoge",
        "fuga",
        "piyo"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewのカスタマイズをするためにdelegateとdataSourceを設定
        // 今回は自身をUITableViewDelegateとUITableViewDataSourceに準拠させて使う
        tableView.delegate = self
        tableView.dataSource = self
        
        // tableViewで使うセルを登録しておく
        // 登録しておくとcellForRowAtでdequeueReusableCellから取得できるようになる
        // セルの使い回しができる
        // CellReuseIdentifierは使い回し時にも使うのでプロパティに切り出すのがおすすめ
        let nib = UINib(nibName: "RepositoryCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
}

// UITableViewDelegateとUITableViewDataSourceに準拠
// extensionに切り出すと可読性が上がる
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // viewDidLoadで登録しておいたセルを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RepositoryCell
        cell.set(repositoryName: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セル選択後に呼ばれる
        // 押されたセルの場所(indexPath)などに応じて処理を変えることができるが
        // 今回は必ずDetailViewControllerに遷移するように実装
        let detailView = DetailViewController()
        
        // navigationController:画面遷移を司るクラス
        // pushViewController(_:animated:)で画面遷移できる
        navigationController?.pushViewController(detailView, animated: true)
    }
}
