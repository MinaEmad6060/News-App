//
//  FavouriteArticlesViewController.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit

class FavouriteArticlesViewController: UIViewController {

    var coordinator: Coordinator!
    var favArticles = [ArticleViewData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let customView = FavouriteView(favArticles: favArticles)
        customView.frame = view.bounds
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customView.coordinator = coordinator
        
        view.addSubview(customView)
    }

}
