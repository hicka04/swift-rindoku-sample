//
//  User.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/10/11.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object, Decodable {
    
    @objc dynamic private(set) var id: Int
    @objc dynamic private(set) var login: String
}
