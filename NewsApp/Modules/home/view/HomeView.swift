//
//  AllNewsView.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit
import Combine
import os


class HomeView: UIView{
    
    // MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    
    // MARK: - Properties
    private let logger = Logger(subsystem: "com.NewsApp.View", category: "View")
    private var handler = HomeHandler()
    private var cancellables = Set<AnyCancellable>()
    var coordinator: Coordinator?

//    private let errorLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .red
//        label.font = UIFont.preferredFont(forTextStyle: .body)
//        label.isHidden = true
//        label.textAlignment = .center
//        return label
//    }()
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
        
        cell.articleTitle.text = handler.homeArticles[indexPath.item].title
        cell.articleAuthor.text = handler.homeArticles[indexPath.item].author
        cell.articleDetails.text = handler.homeArticles[indexPath.item].content
        loadImage(for: cell, at: indexPath)

        return cell
    }

    func loadImage(for cell: ArticleCollectionViewCell, at indexPath: IndexPath) {
        guard let url = URL(string: handler.homeArticles[indexPath.item].urlToImage ?? "") else {
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching image: \(error)")
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    print("Failed to convert data to image")
                    return
                }

                // Update UI on the main thread
                DispatchQueue.main.async {
                    // Make sure the cell is still visible
                    if let currentCell = self.articlesCollectionView.cellForItem(at: indexPath) as? ArticleCollectionViewCell {
                        currentCell.articleImage.image = image
                    }
                }
            }

            task.resume()
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
