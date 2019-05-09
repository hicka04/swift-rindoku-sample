//
//  RootRouter.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2019/05/09.
//  Copyright © 2019 hicka04. All rights reserved.
//

import UIKit

class RootRouter {
    
    private let window: UIWindow
    private var tab: UITabBarController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func showFirstView() {
        tab = TabBarController()
        window.rootViewController = tab
        window.makeKeyAndVisible()
    }
}
