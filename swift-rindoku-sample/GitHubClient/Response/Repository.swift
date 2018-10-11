//
//  Repository.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/10/11.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation

struct Repository: Decodable {
    
    let id: Int
    let name: String
    let fullName: String
    let htmlUrl: String
    let owner: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case htmlUrl = "html_url"
        case owner
    }
}
