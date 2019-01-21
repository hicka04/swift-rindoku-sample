//
//  DetailViewController.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/09/27.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit
import WebKit

class RepositoryDetailViewController: UIViewController {
    
    // iOS10未満を対応しているアプリで
    // WKWebViewをXibで配置するとクラッシュするので注意(バグです)
    @IBOutlet private weak var webView: WKWebView!
    private let repository: Repository
    private var isBookmarked: Bool = false {
        didSet {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: isBookmarked ? #imageLiteral(resourceName: "bookmark") : #imageLiteral(resourceName: "bookmark_border"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(bookmarkButtonDidTap))
        }
    }
    
    init(repository: Repository) {
        self.repository = repository
        
        super.init(nibName: nil, bundle: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: isBookmarked ? #imageLiteral(resourceName: "bookmark") : #imageLiteral(resourceName: "bookmark_border"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(bookmarkButtonDidTap))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = repository.fullName

        let url = URL(string: repository.htmlUrl)!
        webView.load(URLRequest(url: url))
    }
    
    @objc private func bookmarkButtonDidTap() {
        isBookmarked.toggle()
    }
}
