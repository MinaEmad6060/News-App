//
//  NewsURL.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation

struct NewsURL {
    
    private static let baseNewsURLString = "https://newsapi.org/v2/"
    private static let apiKey = "d9bf8e6d78424fb185fa42e4db103e8a"
    

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

    
    
    static var newsListUrl: URL? {
        return newsURL(endpoint: .everything, parameters: ["q":"apple"])
    }

}
