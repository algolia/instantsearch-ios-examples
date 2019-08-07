//
//  MovieCell.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 18/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit

protocol MovieCell {
  
  var artworkImageView: UIImageView { get }
  var titleLabel: UILabel { get }
  var genreLabel: UILabel { get }
  var yearLabel: UILabel { get }
  
}
