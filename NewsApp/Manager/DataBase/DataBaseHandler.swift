//
//  DataBaseHandler.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation
import CoreData
import UIKit
import os

class DataBaseHandler {
    
    private let logger = Logger(subsystem: "com.NewsApp.networking", category: "database")
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let shared = DataBaseHandler()

    func getAllItems() throws -> [FavouriteArticle] {
        var favouriteArticles = [FavouriteArticle]()
        
        let fetchRequest: NSFetchRequest<FavouriteArticle> = FavouriteArticle.fetchRequest()
        
        do {
            favouriteArticles = try context.fetch(fetchRequest)
        } catch {
            logger.error("Failed to fetch articles: \(error.localizedDescription)")
            throw CSError.failedToFetch
        }
        
        return favouriteArticles
    }
    
    func addItem(article: ArticleViewData) throws -> Bool{
        var isAddedSuccessfully = true
        let fetchRequest: NSFetchRequest<FavouriteArticle> = FavouriteArticle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title ?? "")
        
        do {
            let existingArticles = try context.fetch(fetchRequest)
            
            if existingArticles.isEmpty {
                let favouriteArticle = FavouriteArticle(context: context)
                favouriteArticle.title = article.title
                favouriteArticle.author = article.author
                favouriteArticle.content = article.content
                favouriteArticle.urlToImage = article.urlToImage
                
                try context.save()
                DispatchQueue.main.async {
                    isAddedSuccessfully = true
                }
            } else {
                isAddedSuccessfully = false
            }
        } catch {
            logger.error("Failed to save article: \(error.localizedDescription)")
            throw CSError.failedToSave
        }
        
        return isAddedSuccessfully
    }
    
}
