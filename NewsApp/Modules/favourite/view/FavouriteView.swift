//
//  FavouriteView.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit
import Combine
import os
import Kingfisher

class FavouriteView: UIView{
    
    // MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    @IBOutlet weak var noDataView: NoDataView!
    
    // MARK: - Properties
    private let logger = Logger(subsystem: "com.NewsApp.View", category: "View")
    private var cancellables = Set<AnyCancellable>()
    var coordinator: Coordinator?
    var article = ArticleViewData()
    var favArticles = [ArticleViewData]()
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init(favArticles: [ArticleViewData]) {
        self.favArticles = favArticles
        super.init(frame: .zero)
        commonInit()
        articlesCollectionView.reloadData()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "FavouriteView", bundle: nil)
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
        
        initCollectionView()
        initArticlesList()
    }
    
    private func initArticlesList() {
        do {
            let articles = try DataBaseHandler.shared.getAllItems()
            var favArticle = ArticleViewData()
            for article in articles {
                favArticle.title = article.title
                favArticle.author = article.author
                favArticle.content = article.content
                favArticle.urlToImage = article.urlToImage
                self.favArticles.append(favArticle)
            }
            articlesCollectionView.reloadData()
        } catch let error as CSError {
            logger.error("\(error.rawValue)")
        } catch {
            logger.error("An unexpected error occurred while fetching")
        }
    }

    // MARK: - Handle Buttons

    @IBAction func btnBack(_ sender: Any) {
        coordinator?.pop()
    }
    
}

// MARK: - Collection View

extension FavouriteView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.favArticles.count == 0{
            noDataView.isHidden = false
        }else{
            noDataView.isHidden = true
        }
        return self.favArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
        
        cell.articleTitle.text = favArticles[indexPath.item].title ?? "Not Found"
        cell.articleAuthor.text = favArticles[indexPath.item].author ?? "Not Found"
        cell.articleDetails.text = favArticles[indexPath.item].content ?? "Not Found"
        
        if let urlString = favArticles[indexPath.row].urlToImage,
           let url = URL(string: urlString) {
            cell.articleImage.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "folder.fill")
            )
        } else {
            cell.articleImage.image = UIImage(systemName: "folder.fill")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        article.title = favArticles[indexPath.item].title ?? "Not Found"
        article.author = favArticles[indexPath.item].author ?? "Not Found"
        article.content = favArticles[indexPath.item].content ?? "Not Found"
        article.urlToImage = favArticles[indexPath.item].urlToImage ?? "Not Found"
        
        let articleDetailsViewController = ArticleDetailsViewController()
        articleDetailsViewController.article = article
        articleDetailsViewController.coordinator = coordinator
        self.getViewController()?.navigationController?.setNavigationBarHidden(true, animated: false)
        self.getViewController()?.navigationController?.pushViewController(articleDetailsViewController, animated: true)
    }
    
    private func initCollectionView(){
        articlesCollectionView.delegate = self
        articlesCollectionView.dataSource = self
        
        let customCell = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        articlesCollectionView.register(customCell, forCellWithReuseIdentifier: "articleCollectionViewCell")
        
        setupCollectionViewDimensions()
    }
    
    
    private func setupCollectionViewDimensions(){
        let layout = UICollectionViewFlowLayout()
        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 4

        let totalSpacing = (numberOfColumns - 1) * spacing
        let width = (articlesCollectionView.frame.width - totalSpacing) / numberOfColumns
        layout.itemSize = CGSize(width: width, height: 300)

        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing

        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        articlesCollectionView.collectionViewLayout = layout
    }

}
