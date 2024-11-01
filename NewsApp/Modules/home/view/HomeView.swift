//
//  HomeView.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import Foundation
import UIKit
import Combine

class HomeView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var view: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    private var handler = HomeHandler()
    private var cancellables = Set<AnyCancellable>()
    var coordinator: Coordinator?

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupViews()
        setupBindings()
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupViews()
        setupBindings()
        tableView.dataSource = self
    }
    
    private func commonInit() {

        let nib = UINib(nibName: "HomeView", bundle: nil)
        guard let loadedView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view = loadedView
        addSubview(view)
        
        // Set constraints to fill the entire view
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")

    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(errorLabel)
     
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        handler.$homeArticles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        handler.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.errorLabel.text = errorMessage
                    self?.errorLabel.isHidden = false
                    self?.tableView.isHidden = true
                } else {
                    self?.errorLabel.isHidden = true
                    self?.tableView.isHidden = false
                }
            }
            .store(in: &cancellables)
    }
    
   
    
    @IBAction func btnNext(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let viewController1 = storyboard.instantiateViewController(withIdentifier: "ViewController1") as? ViewController1 {
//            viewController1.coordinator = coordinator
//            
//            self.getViewController()?.navigationController?.setNavigationBarHidden(true, animated: false)
//            self.getViewController()?.navigationController?.pushViewController(viewController1, animated: true)
//        }
    }
}

extension HomeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return handler.homeArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        let article = handler.homeArticles[indexPath.row]
        cell.textLabel?.text = article.title
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        return cell
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
