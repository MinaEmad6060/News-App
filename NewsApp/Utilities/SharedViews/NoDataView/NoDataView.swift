//
//  NoDataView.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit

class NoDataView: UIView{
    
    // MARK: - Outlets
    @IBOutlet var view: UIView!
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "NoDataView", bundle: nil)
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
}
