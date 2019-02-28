//
//  UIAlertController+extension.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/11/22.
//  Copyright © 2018 hicka04. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    static func createGitHubErrorAlert(from error: GitHubClientError) -> UIAlertController {
        let message: String
        switch error {
        case .connectionError: message = "通信エラーが発生しました"
        case .responseParseError, .apiError: message = "予期せぬエラーが発生しました"
        }
        
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }
}
