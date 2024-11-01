//
//  NewsRepository.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation

class NewsRepository : NewsRepositoryProtocol {
    
    func fetchNewsList() async throws -> News {
        guard let url = NewsURL.newsListUrl else { throw CSError.invalidURL }
        return try await GenericNetworkService.getData(from: url)
    }
}
