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
            manufacturerLabel.text = item?.manufacturer
            priceLabel.text = String(describing: item?.price)
            reviewCountLabel.text = String(describing: item?.customerReviewCount)
            categoryLabel.text = item?.category
            
            if let url = item?.imageUrl {
                itemImageView.setImageWith(url, placeholderImage: ItemCell.placeholder)
            } else {
                itemImageView.image = ItemCell.placeholder
            }
        }
    }

}
