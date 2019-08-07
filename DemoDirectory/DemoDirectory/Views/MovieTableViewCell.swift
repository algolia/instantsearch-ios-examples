//
//  MovieTableViewCell.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 18/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit

class MovieTableViewCell: UITableViewCell, MovieCell {
  
  let artworkImageView: UIImageView
  let titleLabel: UILabel
  let genreLabel: UILabel
  let yearLabel: UILabel
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    artworkImageView = .init(frame: .zero)
    titleLabel = .init(frame: .zero)
    genreLabel = .init(frame: .zero)
    yearLabel = .init(frame: .zero)
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layout() {
    
    artworkImageView.translatesAutoresizingMaskIntoConstraints = false
    artworkImageView.clipsToBounds = true
    artworkImageView.contentMode = .scaleAspectFill
    artworkImageView.layer.masksToBounds = true
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
    titleLabel.numberOfLines = 0
    
    genreLabel.translatesAutoresizingMaskIntoConstraints = false
    genreLabel.font = .systemFont(ofSize: 10, weight: .regular)
    genreLabel.textColor = .gray
    genreLabel.numberOfLines = 0
    
    yearLabel.translatesAutoresizingMaskIntoConstraints = false
    yearLabel.font = .systemFont(ofSize: 10, weight: .regular)
    yearLabel.textColor = .gray
    yearLabel.numberOfLines = 0
    
    let mainStackView = UIStackView()
    mainStackView.axis = .horizontal
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.spacing = 5
    
    let labelsStackView = UIStackView()
    labelsStackView.axis = .vertical
    labelsStackView.translatesAutoresizingMaskIntoConstraints = false
    labelsStackView.spacing = 3
    
    labelsStackView.addArrangedSubview(titleLabel)
    labelsStackView.addArrangedSubview(genreLabel)
    labelsStackView.addArrangedSubview(yearLabel)
    labelsStackView.addArrangedSubview(UIView())
    
    let artworkImageContainer = UIView()
    artworkImageContainer.translatesAutoresizingMaskIntoConstraints = false
    artworkImageContainer.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    artworkImageContainer.addSubview(artworkImageView)
    artworkImageView.pin(to: artworkImageContainer.layoutMarginsGuide)
    
    mainStackView.addArrangedSubview(artworkImageContainer)
    mainStackView.addArrangedSubview(labelsStackView)
    
    contentView.addSubview(mainStackView)
    
    artworkImageView.widthAnchor.constraint(equalTo: artworkImageView.heightAnchor).isActive = true
    
    mainStackView.pin(to: contentView)
  }
  
}
