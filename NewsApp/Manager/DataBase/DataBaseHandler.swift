//
//  DataBaseHandler.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation
import CoreData
import UIKit

class DataBaseHandler {
    
    static let shared = DataBaseHandler()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllItems() -> [FavouriteArticle] {
        var favouriteArticles = [FavouriteArticle]()
        
        let fetchRequest: NSFetchRequest<FavouriteArticle> = FavouriteArticle.fetchRequest()
        
        do {
            favouriteArticles = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                print("Fetched favouriteArticles: \(favouriteArticles)")
            }
        } catch {
            print("Failed to fetch articles: \(error.localizedDescription)")
        }
        
        return favouriteArticles
    }
    
    func addItem(article: ArticleViewData) {
        let favouriteArticle = FavouriteArticle(context: context)
        favouriteArticle.title = article.title
        favouriteArticle.author = article.author
        favouriteArticle.content = article.content
        favouriteArticle.urlToImage = article.urlToImage
        
        do {
            try context.save()
            DispatchQueue.main.async {
                print("Added favouriteArticle: \(favouriteArticle)")
            }
        } catch {
            print("Failed to save article: \(error.localizedDescription)")
        }
    }
    
    
//    func deleteItem(article: FavouriteArticle) {
//        context.delete(article)
//        
//        do {
//            try context.save()
//            DispatchQueue.main.async {
//                print("Deleted favouriteArticle: \(article)")
//            }
//        } catch {
//            print("Failed to delete article: \(error.localizedDescription)")
//        }
//    }
    
}
