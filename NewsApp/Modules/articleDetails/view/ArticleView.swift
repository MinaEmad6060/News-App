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
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var articleDetails: UITextView!
    @IBOutlet weak var btnAddToFavouritesOutlet: UIButton!
    
    // MARK: - Properties
    private let logger = Logger(subsystem: "com.NewsApp.View", category: "View")
    var coordinator: Coordinator?
    var article: ArticleViewData?


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
    
    init(article: ArticleViewData) {
        self.article = article
        super.init(frame: .zero)
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
        articleImage.layer.cornerRadius = 20
        articleAuthor.layer.cornerRadius = 20
        btnAddToFavouritesOutlet.layer.cornerRadius = 26
        articleDetails.isEditable = false
        
        articleTitle.text = article?.title
        articleAuthor.text = article?.author
        articleAuthor.clipsToBounds = true
        articleDetails.text = article?.content
        

        if let urlString = article?.urlToImage,
           let url = URL(string: urlString) {
            articleImage.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "folder.fill")
            )
        } else {
            articleImage.image = UIImage(systemName: "folder.fill")
        }
    }

    // MARK: - Alert
    func showAlert(in viewController: UIViewController, title: String, message: String, handler: @escaping (UIAlertAction)->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: handler)
        
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Handle Buttons
    @IBAction func btnBack(_ sender: Any) {
        coordinator?.pop()
    }
    
    @IBAction func btnAddToFavourites(_ sender: Any) {
        guard let article = article else {
            showAlert(in: self.getViewController() ?? UIViewController(), title: "Error", message: "Invalid article data.") { _ in }
            return
        }
        
        do {
            let isAlreadyAdded = try DataBaseHandler.shared.addItem(article: article)
            
            if isAlreadyAdded {
                showAlert(in: self.getViewController() ?? UIViewController(), title: article.author ?? "", message: "Added to favourite successfully") { _ in
                    self.coordinator?.pop()
                }
            } else {
                showAlert(in: self.getViewController() ?? UIViewController(), title: article.author ?? "", message: "This article is already in favourites") { _ in }
            }
        } catch let error as CSError {
            showAlert(in: self.getViewController() ?? UIViewController(), title: "Error", message: error.rawValue) { _ in }
        } catch {
            showAlert(in: self.getViewController() ?? UIViewController(), title: "Error", message: "An unexpected error occurred.") { _ in }
        }
    }

    
}
