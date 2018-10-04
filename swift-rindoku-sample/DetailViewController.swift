//
//  DetailViewController.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/09/27.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://www.google.co.jp/")!
        webView.load(URLRequest(url: url))
    }
}
