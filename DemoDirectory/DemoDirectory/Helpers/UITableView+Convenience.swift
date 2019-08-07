//
//  UITableView+Convenience.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
  
  func scrollToFirstNonEmptySection() {
    (0..<numberOfSections)
      .first(where: { numberOfRows(inSection: $0) > 0 })
      .flatMap { IndexPath(row: 0, section: $0) }
      .flatMap { scrollToRow(at: $0, at: .top, animated: false) }
  }
  
}

extension UICollectionView {
  
  func scrollToFirstNonEmptySection() {
    (0..<numberOfSections)
      .first(where: { numberOfItems(inSection: $0) > 0 })
      .flatMap { IndexPath(item: 0, section: $0) }
      .flatMap { scrollToItem(at: $0, at: .top, animated: false) }
    
  }
  
}
