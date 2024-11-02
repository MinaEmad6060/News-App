//
//  CSError.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation

enum CSError : String,Error {
    case unableToComplete = "Unable to completed your request. Please check your internet connection."
    case invailedResponse = "Invalid response from the server.Please try again"
    case invailedData = "The data received from the server was invailed. Please try again."
    case invalidURL = "The URL for the request could not be created."
    case failedToFetch = "Failed to fetch items from the database."
    case failedToSave = "Failed to save the item to the database."
}
