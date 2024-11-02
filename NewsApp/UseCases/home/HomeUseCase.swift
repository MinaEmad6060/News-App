//
//  HomeUseCase.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation


class HomeUseCase: HomeUseCaseProtocol {
    private let repository: NewsRepositoryProtocol
    
    init(repository: NewsRepositoryProtocol = NewsRepository()) {
        self.repository = repository
    }
    
    func fetchNewsArticles(searchQuery: String) async throws -> News {
        return try await repository.fetchNewsList(searchQuery: searchQuery)
    }
  
}
