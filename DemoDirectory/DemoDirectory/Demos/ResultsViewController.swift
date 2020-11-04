//
//  ResultsViewController.swift
//  QuerySuggestions
//
//  Created by Vladislav Fitc on 27/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch
import SDWebImage

public class ResultsViewController: UITableViewController, HitsController {
    
  public var hitsSource: HitsInteractor<ShopItem>?
  
  let cellID = "cellID"
  
  public override init(style: UITableView.Style) {
    super.init(style: style)
    tableView.register(ShopItemTableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func reload() {
    tableView.reloadData()
  }
  
  public func scrollToTop() {
    tableView.scrollToFirstNonEmptySection()
  }
  
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
  
  public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
}
