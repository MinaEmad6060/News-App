//
//  NewsRepositoryProtocol.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation

protocol NewsRepositoryProtocol{
    func fetchNewsList() async throws -> News
}
