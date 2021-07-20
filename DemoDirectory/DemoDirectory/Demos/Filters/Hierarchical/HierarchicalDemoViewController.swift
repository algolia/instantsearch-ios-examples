//
//  HierarchicalDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 08/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class HierarchicalDemoViewController: UIViewController {
  
  let demoController: HierarchicalDemoController

  let hierarchicalTableViewController: HierarchicalTableViewController

  let tableViewController: UITableViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    tableViewController = .init(style: .plain)
    hierarchicalTableViewController = .init(tableView: tableViewController.tableView)
    demoController = .init(controller: hierarchicalTableViewController)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    addChild(tableViewController)
    tableViewController.didMove(toParent: self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    view.backgroundColor = . white
    let tableView = tableViewController.view!
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    tableView.pin(to: view.safeAreaLayoutGuide)
  }

}

