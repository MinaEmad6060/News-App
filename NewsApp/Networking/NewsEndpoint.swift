//
//  NewsEndpoint.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation

enum NewsEndpoint {
    
    case everything

    var rawValue: String {
        switch self {
            case .everything: return "everything"
        }
    }
}
