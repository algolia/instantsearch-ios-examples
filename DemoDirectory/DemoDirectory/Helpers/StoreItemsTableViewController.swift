//
//  EcomHitsTableViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 21/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class StoreItemsTableViewController: UITableViewController, HitsController {
    
  let cellIdentifier = "cellID"
  
  var hitsSource: HitsInteractor<Hit<StoreItem>>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
  }
    
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let hitsCount = hitsSource?.numberOfHits() ?? 0
    if hitsCount == 0 {
      tableView.setEmptyMessage("No results")
    } else {
      tableView.restore()
    }
    return hitsCount
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductTableViewCell else {
      return UITableViewCell()
    }
    guard let hit = hitsSource?.hit(atIndex: indexPath.row) else {
      return cell
    }
    cell.setup(with: hit)
    return cell
  }
    
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
    
}
