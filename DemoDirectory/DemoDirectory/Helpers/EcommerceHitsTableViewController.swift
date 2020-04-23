//
//  EcommerceHitsTableViewController.swift
//  DemoDirectory
//
//  Created by test test on 20/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

struct Product: Codable {
  let name: String
  let brand: String
  let type: String
  let categories: [String]
  let image: URL
}

class EcommerceHitsTableViewController: UITableViewController, InstantSearchCore.HitsController {
  
  
  var cellIdentifier = "CellID"
  var didSelect: ((Hit<Product>) -> ())?
  
  var hitsSource: HitsInteractor<Hit<Product>>?
  
  init() {
    super.init(nibName: .none, bundle: .none)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func reload() {
    tableView.reloadData()
  }
  
  func scrollToTop() {
    tableView.scrollToFirstNonEmptySection()
  }
  
  //MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    let hit = hitsSource?.hit(atIndex: indexPath.row)
    
    if let ecommerceHit = hit?.object {
      (cell as? UIView & MovieCell).flatMap(MovieCellViewState().configure)?(ecommerceHit)
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let hit = hitsSource?.hit(atIndex: indexPath.row) {
      didSelect?(hit)
    }
    
  }
  
  //MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
}
