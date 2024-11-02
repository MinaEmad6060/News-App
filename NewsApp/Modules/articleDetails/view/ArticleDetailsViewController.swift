//
//  ArticleDetailsViewController.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit

class ArticleDetailsViewController: UIViewController {

    var coordinator: Coordinator!
    var article = ArticleViewData()

    override func viewDidLoad() {
        super.viewDidLoad()

        let customView = ArticleView(article: article)
        customView.frame = view.bounds
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customView.coordinator = coordinator
        
        view.addSubview(customView)
    }


}
