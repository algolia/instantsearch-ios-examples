//
//  FilterViewController.swift
//  Icebnb
//
//  Created by Robert Mogos on 06/09/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import KUIPopOver

public typealias FilterBlock = (UIViewController) -> Void

class FilterViewController: UITableViewController, KUIPopOverUsable {
  
  let filterActions: [String: FilterBlock]
  let filters: [String]
  
  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, filters: [String: FilterBlock]) {
    self.filterActions = filters
    self.filters = self.filterActions.flatMap() { $0.key }
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "filterCell")
    super.viewDidLoad()
    self.title = "Filters"
  }
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filterActions.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath)
    cell.textLabel?.text = filters[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let block = filterActions[filters[indexPath.row]] {
      block(self)
    }
    
  }
  
  var contentSize: CGSize {
    get {
      let size = CGSize(width: PopoverConstants.popoverWidth,
                        height: PopoverConstants.popoverCellHeight * CGFloat(integerLiteral: filters.count))
      return size
    }
  }
  var contentView: UIView {
    get {
      return self.view
    }
  }
  
  var arrowDirection: UIPopoverArrowDirection {
    get {
      return .up
    }
  }
}
