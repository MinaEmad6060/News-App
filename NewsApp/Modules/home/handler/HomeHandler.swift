//
//  HomeHandler.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation
import Combine
import os

extension HomeView {
    
    @MainActor
    class HomeHandler: ObservableObject {
        //MARK: - PROPERTIES
        
        @Published var homeArticles: [Article] = []
        @Published var errorMessage: String?
        
        private let logger = Logger(subsystem: "com.NewsApp.networking", category: "HomeHandler")
        private let useCase: HomeUseCaseProtocol
        
        init(useCase: HomeUseCaseProtocol = HomeUseCase(), searchQuery: String, fromDate: String) {
            self.useCase = useCase
            Task {
                await self.getHomeArticles(searchQuery: searchQuery, fromDate: fromDate)
            }
        }
        
        //MARK: - getHomeArticles
        func getHomeArticles(searchQuery: String, fromDate: String) async {
            do {
                let articles = try await useCase.fetchNewsArticles(searchQuery: searchQuery, fromDate: fromDate)
                homeArticles = articles.articles ?? []
            } catch {
                handleError(error)
            }
        }
        
        // MARK: - Error Handling
        private func handleError(_ error: Error) {
            let errorMessage = error.localizedDescription
            logger.error("Error fetching data: \(errorMessage)")
            self.errorMessage = errorMessage
        }
    }
}
