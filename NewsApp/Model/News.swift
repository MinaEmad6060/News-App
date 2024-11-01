//
//  News.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation


struct News: Decodable {
    let articles: [Article]?
}

struct Article: Decodable {
    let author: String?
    let title: String?
    let urlToImage: String?
    let content: String?
}
