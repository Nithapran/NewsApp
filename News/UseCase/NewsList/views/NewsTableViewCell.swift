//
//  NewsTableViewCell.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-09.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    var news: News?
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        container.layer.shadowOffset = CGSize(width: 0,
                                          height: 2)
        container.layer.shadowRadius = 5
        container.layer.shadowOpacity = 0.15
        container.layer.masksToBounds = false
        container.layer.cornerRadius = 10
        authorLabel.text = news?.author ?? "Unknown"
        newsTitle.text = news?.title
        newsImageView.sd_setImage(with: URL(string: news?.urlToImage ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        newsImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
