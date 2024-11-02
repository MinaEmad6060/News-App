//
//  AllNewsView.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit
import Combine
import os
import Kingfisher

class HomeView: UIView{
    
    // MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    
    // MARK: - Properties
    private let logger = Logger(subsystem: "com.NewsApp.View", category: "View")
    private var handler = HomeHandler()
    private var cancellables = Set<AnyCancellable>()
    var coordinator: Coordinator?

    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setupBindings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupBindings()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "HomeView", bundle: nil)
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
    
    // MARK: - Bindings
    private func setupBindings() {
        handler.$homeArticles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.articlesCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        handler.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { /*[weak self]*/ errorMessage in
//                if let errorMessage = errorMessage {
//                    self?.articlesCollectionView.isHidden = true
//                } else {
//                    self?.articlesCollectionView.isHidden = false
//                }
            }
            .store(in: &cancellables)
    }
    

    
    @IBAction func btnFavourites(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let viewController1 = storyboard.instantiateViewController(withIdentifier: "ViewController1") as? ViewController1 {
//            viewController1.coordinator = coordinator
//            
//            self.getViewController()?.navigationController?.setNavigationBarHidden(true, animated: false)
//            self.getViewController()?.navigationController?.pushViewController(viewController1, animated: true)
//        }
    }
    
    
}


extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.logger.info("homeArticles-count \(self.handler.homeArticles.count)")
        return handler.homeArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
        
        cell.articleTitle.text = handler.homeArticles[indexPath.item].title ?? "Not Found"
        cell.articleAuthor.text = handler.homeArticles[indexPath.item].author ?? "Not Found"
        cell.articleDetails.text = handler.homeArticles[indexPath.item].content ?? "Not Found"
        if let urlString = handler.homeArticles[indexPath.row].urlToImage,
           let url = URL(string: urlString) {
            cell.articleImage.kf.setImage(with: url)
        } else {
            cell.articleImage.image = UIImage(systemName: "folder.fill")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

extension UIView {
    func getViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.getViewController()
        } else {
            return nil
        }
    }
}
