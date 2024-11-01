//
//  GenericNetworkService.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation
import os

struct GenericNetworkService {
    
    private static let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    private static let logger = Logger(subsystem: "com.NewsApp.networking", category: "network")
    
    
    static func getData<T: Decodable>(from url: URL) async throws -> T {
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                logger.error("Invalid response from server for URL: \(url.absoluteString)")
                throw CSError.invailedResponse
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
            
        } catch {
            if let urlError = error as? URLError {
                logger.error("URL error: \(urlError.localizedDescription) for URL: \(url.absoluteString)")
                throw CSError.unableToComplete
            } else if let decodingError = error as? DecodingError {
                logger.error("Decoding error: \(decodingError.localizedDescription) for URL: \(url.absoluteString)")
                throw CSError.invailedData
            } else {
                logger.error("Unknown error: \(error.localizedDescription) for URL: \(url.absoluteString)")
                throw CSError.unableToComplete
            }
        }
    }

    
}
