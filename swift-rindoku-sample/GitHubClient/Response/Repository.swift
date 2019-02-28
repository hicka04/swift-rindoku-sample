//
//  Repository.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/10/11.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

class Repository: Object, Decodable {
    
    @objc dynamic private(set) var id: Int = 0
    @objc dynamic private(set) var name: String = ""
    @objc dynamic private(set) var fullName: String = ""  // 詳細ページ表示用に追加
    @objc dynamic private(set) var htmlUrl: String = ""
    @objc dynamic private(set) var owner: User!
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case htmlUrl = "html_url"
        case owner
    }
}
