//
//  NewsURL.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation

struct NewsURL {
    
    private static let baseNewsURLString = "https://newsapi.org/v2/"
    private static let apiKey = "3d5e47f5f8d343039a38d03cb7928d08"
    
    private static func newsURL(endpoint: NewsEndpoint, parameters: [String: String]?) -> URL? {
        
        guard var components = URLComponents(string: baseNewsURLString + endpoint.rawValue) else {
            return nil
        }
        
        var queryItems: [URLQueryItem] = []
        
        let baseParams: [String: String] = [
            "apiKey": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParameters = parameters {
            for (key, value) in additionalParameters {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            return nil
        }
        
        return url
    }

   
    static func newsListUrl(with searchQuery: String, fromDate: String) -> URL? {
        let parameters: [String: String] = [
            "q": searchQuery,
            "from": fromDate
        ]
        return newsURL(endpoint: .everything, parameters: parameters)
    }
}
