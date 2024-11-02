//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation

class NewsRepository : NewsRepositoryProtocol {
    
    func fetchNewsList(searchQuery: String, fromDate: String) async throws -> News {
        guard let url = NewsURL.newsListUrl(with: searchQuery, fromDate: fromDate) else {
            throw CSError.invalidURL
        }
        return try await GenericNetworkService.getData(from: url)
    }
    
}
