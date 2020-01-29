//
//  ResultsViewController.swift
//  SearchSuggestions
//
//  Created by Vladislav Fitc on 27/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore
import SDWebImage

class ResultsViewController: UITableViewController, HitsController {
    
  var hitsSource: HitsInteractor<ShopItem>?
  
  let cellID = "cellID"
  
  override init(style: UITableView.Style) {
    super.init(style: style)
    tableView.register(ShopItemTableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func reload() {
    tableView.reloadData()
  }
  
  func scrollToTop() {
    tableView.scrollToFirstNonEmptySection()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? ShopItemTableViewCell,
      let item = hitsSource?.hit(atIndex: indexPath.row) else {
        return .init()
    }
    cell.itemImageView.sd_setImage(with: item.image)
    cell.titleLabel.text = item.name
    cell.subtitleLabel.text = item.brand
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
}
