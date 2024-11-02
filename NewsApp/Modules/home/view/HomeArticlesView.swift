//
//  HomeView.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit
import Combine

class HomeArticlesView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var btn123: UIButton!
    
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
//        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupViews()
        setupBindings()
//        tableView.dataSource = self
    }
    
    private func commonInit() {

        let nib = UINib(nibName: "HomeArticlesView", bundle: nil)
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
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")

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
//                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        handler.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.errorLabel.text = errorMessage
                    self?.errorLabel.isHidden = false
//                    self?.tableView.isHidden = true
                } else {
                    self?.errorLabel.isHidden = true
//                    self?.tableView.isHidden = false
                }
            }
            .store(in: &cancellables)
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
