//
//  ProductTableViewCell+ProductHit.swift
//  Examples
//
//  Created by Vladislav Fitc on 13/12/2021.
//

import Foundation
import UIKit
import AlgoliaSearchClient
import InstantSearchCore

extension ProductTableViewCell {
  
  func setup(with productHit: Hit<Product>) {
    let product = productHit.object
    itemImageView.sd_setImage(with: product.image)
    
    if let highlightedName = productHit.hightlightedString(forKey: "name") {
      titleLabel.attributedText = NSAttributedString(highlightedString: highlightedName,
                                                     attributes: [
                                                      .foregroundColor: UIColor.tintColor])
    } else {
      titleLabel.text = product.name
    }
    
    if let highlightedDescription = productHit.hightlightedString(forKey: "description") {
      subtitleLabel.attributedText = NSAttributedString(highlightedString: highlightedDescription,
                                                        attributes: [
                                                          .foregroundColor: UIColor.tintColor
                                                        ])
    } else {
      subtitleLabel.text = product.description
    }
    
  }
  
}

