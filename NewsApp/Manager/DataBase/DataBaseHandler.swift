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
    
    func addItem(article: ArticleViewData) -> Bool{
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
                    print("Added favouriteArticle flag: \(isAddedSuccessfully)")
                }
            } else {
                isAddedSuccessfully = false
                print("Article already exists in favourites")
            }
        } catch {
            print("Failed to save article: \(error.localizedDescription)")
        }
        
        return isAddedSuccessfully
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
