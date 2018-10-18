//
//  GitHubRequset.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2018/10/11.
//  Copyright © 2018年 hicka04. All rights reserved.
//

import Foundation

protocol GitHubRequset {
    
    associatedtype Response: Decodable
    
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}

extension GitHubRequset {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}
