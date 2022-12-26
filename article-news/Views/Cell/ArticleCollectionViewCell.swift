//
//  ArticleCollectionViewCell.swift
//  article-news
//
//  Created by Roby Setiawan on 26/12/22.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var fotoArtikel: TSImageView!
    
    @IBOutlet var judulArtikel: UILabel!
    
    
    @IBOutlet var sourceArtikel: UILabel!
    
    @IBOutlet var tanggalPublishArtikel: UILabel!
    
    static let identifier = "ArticleCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier,
                     bundle: Bundle.main)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }
    
    func setupCell() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        if #available(iOS 13.0, *) {
            self.contentView.layer.borderWidth = 0.2
            self.contentView.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    func configureCellArtikel(with newsitems: ArticleElement, ltr: Bool) {
        self.judulArtikel.text = newsitems.title
        self.sourceArtikel.text = newsitems.author
        self.tanggalPublishArtikel.text = newsitems.publishedAt?.dateFromTimestamp?.relativelyFormatted(short: true)
        if let imageURL = newsitems.urlToImage {
            self.fotoArtikel.downloadedFromLink(imageURL)
        }
        if ltr {
            self.judulArtikel.textAlignment = .right
            self.sourceArtikel.textAlignment = .right
        } else {
            self.judulArtikel.textAlignment = .left
            self.sourceArtikel.textAlignment = .left
        }
    }
}
