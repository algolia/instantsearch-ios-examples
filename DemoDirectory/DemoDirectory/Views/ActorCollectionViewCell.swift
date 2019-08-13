//
//  ActorCollectionViewCell.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 18/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit

class ActorCollectionViewCell: UICollectionViewCell {
  
  let nameLabel: UILabel
  
  override init(frame: CGRect) {
    self.nameLabel = UILabel(frame: .zero)
    super.init(frame: frame)
    layout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layout() {
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.textAlignment = .center
    nameLabel.numberOfLines = 0
    nameLabel.font = .systemFont(ofSize: 13, weight: .medium)
    contentView.backgroundColor = .white
    contentView.addSubview(nameLabel)
    nameLabel.pin(to: contentView.layoutMarginsGuide)
  }
  
}


