//
//  ArticleCollectionViewCell.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var articleDetails: UILabel!
    
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 11.36
        articleImage.layer.cornerRadius = 11.36
        articleAuthor.layer.cornerRadius = 10
        articleAuthor.clipsToBounds = true
    }

}
