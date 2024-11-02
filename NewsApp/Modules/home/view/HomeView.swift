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
    @IBOutlet weak var articleSearchBar: UISearchBar!
    @IBOutlet weak var articleDatePicker: UIDatePicker!
    @IBOutlet weak var noDataView: NoDataView!
    
    // MARK: - Properties
    @Published var searchQuery = "apple"
    @Published var dateQuery = ""
    
    private var handler: HomeHandler?
    private var cancellables = Set<AnyCancellable>()
    
    private let logger = Logger(subsystem: "com.NewsApp.View", category: "View")
    
    var coordinator: Coordinator?
    var article = ArticleViewData()
    let dateFormatter = DateFormatter()
    
    

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
        handler = HomeHandler(searchQuery: self.searchQuery, fromDate: "")
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
        
        initDatePicker()
        initCollectionView()
        setupSearchBar()
    }
    
    
    // MARK: - Bindings
    private func setupBindings() {
        handler?.$homeArticles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.articlesCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        handler?.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.noDataView.isHidden = false
            }
            .store(in: &cancellables)
    }
      
    
    // MARK: - Date Picker
    private func initDatePicker() {
        articleDatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

        articleDatePicker.datePickerMode = .date
        articleDatePicker.tintColor = .blue
        articleDatePicker.date = Date()
        articleDatePicker.maximumDate = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        articleDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let selectedDate = dateFormatter.string(from: sender.date)

        dateQuery = selectedDate
        
        self.getViewController()?.dismiss(animated: false, completion: nil)
    }
    
    @objc private func datePickerChanged() {
        let selectedDate = articleDatePicker.date
        dateQuery = formatDateToString(date: selectedDate)
        Task {
            await handler?.getHomeArticles(searchQuery: searchQuery == "" ? "apple" : searchQuery, fromDate: dateQuery)
        }
    }
    
    private func formatDateToString(date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    
    // MARK: - Handle Buttons

    @IBAction func btnFavourites(_ sender: Any) {
        let favouriteArticlesViewController = FavouriteArticlesViewController()
        favouriteArticlesViewController.coordinator = coordinator
        self.getViewController()?.navigationController?.setNavigationBarHidden(true, animated: false)
        self.getViewController()?.navigationController?.pushViewController(favouriteArticlesViewController, animated: true)
    }
}

// MARK: - Collection View
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if handler?.homeArticles.count ?? 0 == 0{
            self.noDataView.isHidden = false
        }else{
            self.noDataView.isHidden = true
        }
        return handler?.homeArticles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCollectionViewCell", for: indexPath) as! ArticleCollectionViewCell
        
        cell.articleTitle.text = handler?.homeArticles[indexPath.item].title ?? "Not Found"
        cell.articleAuthor.text = handler?.homeArticles[indexPath.item].author ?? "Not Found"
        cell.articleDetails.text = handler?.homeArticles[indexPath.item].content ?? "Not Found"
        if let urlString = handler?.homeArticles[indexPath.row].urlToImage,
           let url = URL(string: urlString) {
            cell.articleImage.kf.setImage(with: url)
        } else {
            cell.articleImage.image = UIImage(systemName: "folder.fill")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        article.title = handler?.homeArticles[indexPath.item].title ?? "Not Found"
        article.author = handler?.homeArticles[indexPath.item].author ?? "Not Found"
        article.content = handler?.homeArticles[indexPath.item].content ?? "Not Found"
        article.urlToImage = handler?.homeArticles[indexPath.item].urlToImage ?? "Not Found"
        
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

// MARK: - Search
extension HomeView: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
    }
    
    private func setupSearchBar() {
        articleSearchBar.delegate = self
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                Task {
                    let searchText = newValue.isEmpty ? "apple" : newValue
                    await self?.handler?.getHomeArticles(searchQuery: searchText, fromDate: self?.dateQuery ?? "")
                }
            }
            .store(in: &cancellables)
    }

}

struct ArticleViewData{
    var author: String?
    var title: String?
    var urlToImage: String?
    var content: String?
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
