//
//  ShopItemTableViewCell.swift
//  QuerySuggestions
//
//  Created by Vladislav Fitc on 27/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit

class ShopItemTableViewCell: UITableViewCell {
  
  let itemImageView: UIImageView
  let titleLabel: UILabel
  let subtitleLabel: UILabel
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    itemImageView = .init(frame: .zero)
    titleLabel = .init(frame: .zero)
    subtitleLabel = .init(frame: .zero)
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layout() {
    
    itemImageView.translatesAutoresizingMaskIntoConstraints = false
    itemImageView.clipsToBounds = true
    itemImageView.contentMode = .scaleAspectFit
    itemImageView.layer.masksToBounds = true
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
    titleLabel.numberOfLines = 0
    
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.font = .systemFont(ofSize: 10, weight: .regular)
    subtitleLabel.textColor = .gray
    subtitleLabel.numberOfLines = 0
        
    let mainStackView = UIStackView()
    mainStackView.axis = .horizontal
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.spacing = 5
    
    let labelsStackView = UIStackView()
    labelsStackView.axis = .vertical
    labelsStackView.translatesAutoresizingMaskIntoConstraints = false
    labelsStackView.spacing = 3
    
    labelsStackView.addArrangedSubview(titleLabel)
    labelsStackView.addArrangedSubview(subtitleLabel)
    labelsStackView.addArrangedSubview(UIView())
    
    let itemImageContainer = UIView()
    itemImageContainer.translatesAutoresizingMaskIntoConstraints = false
    itemImageContainer.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    itemImageContainer.addSubview(itemImageView)
    NSLayoutConstraint.activate([
      itemImageView.topAnchor.constraint(equalTo: itemImageContainer.layoutMarginsGuide.topAnchor),
      itemImageView.bottomAnchor.constraint(equalTo: itemImageContainer.layoutMarginsGuide.bottomAnchor),
      itemImageView.leadingAnchor.constraint(equalTo: itemImageContainer.layoutMarginsGuide.leadingAnchor),
      itemImageView.trailingAnchor.constraint(equalTo: itemImageContainer.layoutMarginsGuide.trailingAnchor),
    ])
    
    mainStackView.addArrangedSubview(itemImageContainer)
    mainStackView.addArrangedSubview(labelsStackView)
    
    contentView.addSubview(mainStackView)
    
    itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor).isActive = true
    
    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
  }
  
}
