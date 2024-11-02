//
//  ArticleView.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit
import Combine
import os
import Kingfisher

class ArticleView: UIView{
    
    // MARK: - Outlets
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var mainBgView: UIView!
    
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var articleDetails: UITextView!
    @IBOutlet weak var btnAddToFavouritesOutlet: UIButton!
    // MARK: - Properties
    private let logger = Logger(subsystem: "com.NewsApp.View", category: "View")
    var coordinator: Coordinator?


    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "ArticleView", bundle: nil)
        guard let loadedView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view = loadedView
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
    
    
    private func setupUI(){
        mainBgView.layer.cornerRadius = 24
        articleAuthor.layer.cornerRadius = 26
        btnAddToFavouritesOutlet.layer.cornerRadius = 35
    }

    
    
   
    
    @IBAction func btnAddToFavourites(_ sender: Any) {

    }
    
    
}
