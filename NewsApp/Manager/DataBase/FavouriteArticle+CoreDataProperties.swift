//
//  FavouriteArticle+CoreDataProperties.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//
//

import Foundation
import CoreData


extension FavouriteArticle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteArticle> {
        return NSFetchRequest<FavouriteArticle>(entityName: "FavouriteArticle")
    }

    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var title: String?
    @NSManaged public var urlToImage: String?

}

extension FavouriteArticle : Identifiable {

}
