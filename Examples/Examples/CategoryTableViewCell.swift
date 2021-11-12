//
//  CategoryTableViewCell.swift
//  Examples
//
//  Created by Vladislav Fitc on 04/11/2021.
//

import Foundation
import UIKit
import InstantSearch

class CategoryTableViewCell: UITableViewCell {
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    imageView?.image = UIImage(systemName: "square.grid.2x2")
    tintColor = .lightGray
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setup(with facet: Facet) {
    guard let textLabel = textLabel else { return }
    if let rawHighlighted = facet.highlighted {
      let highlightedValue = HighlightedString(string: rawHighlighted)
      textLabel.attributedText = NSAttributedString(highlightedString: highlightedValue,
                                                    attributes: [
                                                      .font: UIFont.systemFont(ofSize: textLabel.font.pointSize, weight: .bold)
                                                    ])
    } else {
      textLabel.text = facet.value
    }
  }
  
}
