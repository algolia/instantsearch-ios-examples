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

  struct HierarchicalCategory {
    static var base: Attribute = "hierarchicalCategories"
    static var lvl0: Attribute { return Attribute(rawValue: base.description + ".lvl0")  }
    static var lvl1: Attribute { return Attribute(rawValue: base.description + ".lvl1") }
    static var lvl2: Attribute { return Attribute(rawValue: base.description + ".lvl2") }
  }

  let order = [
    HierarchicalCategory.lvl0,
    HierarchicalCategory.lvl1,
    HierarchicalCategory.lvl2,
  ]

  let searcher: SingleIndexSearcher
  let filterState: FilterState
  let hierarchicalConnector: HierarchicalConnector
  let hierarchicalTableViewController: HierarchicalTableViewController

  let tableViewController: UITableViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = SingleIndexSearcher(client: .demo, indexName: "mobile_demo_hierarchical")
    filterState = .init()
    tableViewController = .init(style: .plain)
    hierarchicalTableViewController = .init(tableView: tableViewController.tableView)
    hierarchicalConnector = .init(searcher: searcher,
                                  filterState: filterState,
                                  hierarchicalAttributes: order,
                                  separator: " > ",
                                  controller: hierarchicalTableViewController,
                                  presenter: DefaultPresenter.Hierarchical.present)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    searcher.connectFilterState(filterState)
    searcher.search()
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
    addChild(tableViewController)
    tableViewController.didMove(toParent: self)
    tableViewController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableViewController.view)
    tableViewController.view.pin(to: view.safeAreaLayoutGuide)
  }

}
