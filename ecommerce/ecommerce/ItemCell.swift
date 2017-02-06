//
//  ItemCell.swift
//  ecommerce
//
//  Created by Guy Daher on 03/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import AFNetworking

class ItemCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let placeholder = UIImage(named: "placeholder")
    
    var item: ItemRecord? {
        didSet {
            nameLabel.highlightedText = item?.title_highlighted
            
            if let manufacturer = item?.manufacturer {
                manufacturerLabel.text = manufacturer
            }
            
            if let price = item?.price {
                priceLabel.text = "$\(String(describing: price))"
            }
            
            if let customerReviewCount = item?.customerReviewCount {
                reviewCountLabel.text = String(describing: customerReviewCount)
            }
            
            categoryLabel.text = item?.category
            itemImageView.cancelImageDownloadTask()
            
            if let url = item?.imageUrl {
                itemImageView.setImageWith(url, placeholderImage: ItemCell.placeholder)
            } else {
                itemImageView.image = ItemCell.placeholder
            }
        }
    }
}
