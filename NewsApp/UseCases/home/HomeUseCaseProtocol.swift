//
//  HomeUseCaseProtocol.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation

protocol HomeUseCaseProtocol {
    func fetchNewsArticles(searchQuery: String, fromDate: String) async throws -> News
}
