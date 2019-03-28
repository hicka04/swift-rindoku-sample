//
//  GitHubRepositoryInteractor.swift
//  swift-rindoku-sample
//
//  Created by SCI01552 on 2019/03/28.
//  Copyright © 2019 hicka04. All rights reserved.
//

import Foundation

protocol GitHubRepositoryUsecase: AnyObject {
    
    func search(from keyword: String,
                completion: @escaping (Result<[Repository], GitHubClientError>) -> Void)
}

final class GitHubRepositoryInteractor {
    
}

extension GitHubRepositoryInteractor: GitHubRepositoryUsecase {
    
    func search(from keyword: String,
                completion: @escaping (Result<[Repository], GitHubClientError>) -> Void) {
        let request = GitHubAPI.SearchRepositories(keyword: keyword)
        GitHubClient().send(request: request) { result in
            switch result {
            case .success(let result):
                completion(.success(result.items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
