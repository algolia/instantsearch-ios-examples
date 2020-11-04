//
//  MultiIndexWidgetHitsViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class MultiIndexWidgetHitsViewController: UITableViewController, MultiIndexHitsController {
  
  var hitsSource: MultiIndexHitsSource?
  
  let actorsSection = 0
  let moviesSection = 1
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    guard let hitsSource = hitsSource else { return 0 }
    return hitsSource.numberOfSections()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let hitsSource = hitsSource else { return .init() }
    return hitsSource.numberOfHits(inSection: section)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let hitsSource = hitsSource else { return .init() }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
    
    switch indexPath.section {
    case actorsSection:
      if let actor: Actor = try? hitsSource.hit(atIndex: indexPath.row, inSection: indexPath.section) {
        cell.textLabel?.text = actor.name
      }
      
    case moviesSection:
      if let movie: Movie = try? hitsSource.hit(atIndex: indexPath.row, inSection: indexPath.section)  {
        cell.textLabel?.text = movie.title
      }
      
    default:
      break
    }
    
    return cell
    
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case actorsSection:
      return "Actors"
    case moviesSection:
      return "Movies"
    default:
      return nil
    }
  }
  
}
