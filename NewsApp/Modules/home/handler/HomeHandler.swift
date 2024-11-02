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

    class HomeHandler: ObservableObject {
        //MARK: - PROPERTIES
        private let logger = Logger(subsystem: "com.NewsApp.networking", category: "HomeHandler")
        
        @Published var homeArticles: [Article] = []
        @Published var errorMessage: String?
        
        private let useCase: HomeUseCaseProtocol
        
        init(useCase: HomeUseCaseProtocol = HomeUseCase()) {
            self.useCase = useCase
            Task {
                await self.getHomeArticles()
            }
        }
        
        //MARK: - getHomeArticles
        func getHomeArticles() async {
            do {
                let articles = try await useCase.fetchNewsArticles()
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
