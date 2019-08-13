//
//  MovieCollectionViewCell.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 18/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit



class MovieCollectionViewCell: UICollectionViewCell, MovieCell {
  
  let artworkImageView: UIImageView
  let titleLabel: UILabel
  let genreLabel: UILabel
  let yearLabel: UILabel
  
  override init(frame: CGRect) {
    artworkImageView = .init(frame: .zero)
    titleLabel = .init(frame: .zero)
    genreLabel = .init(frame: .zero)
    yearLabel = .init(frame: .zero)
    super.init(frame: frame)
    layout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layout() {
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    let stackView = UIStackView()
    stackView.spacing = 4
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    
    contentView.backgroundColor = .white
    contentView.clipsToBounds = true
    contentView.layer.masksToBounds = true
    
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
    
    contentView.addSubview(stackView)
    
    stackView.pin(to: contentView.layoutMarginsGuide)
    
    stackView.addArrangedSubview(artworkImageView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(genreLabel)
    stackView.addArrangedSubview(yearLabel)
    
    artworkImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
    
  }
  
}
