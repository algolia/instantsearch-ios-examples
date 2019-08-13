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
  let hierarchicalInteractor: HierarchicalInteractor
  let hierarchicalTableViewController: HierarchicalTableViewController

  let tableViewController: UITableViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = SingleIndexSearcher(index: .demo(withName: "mobile_demo_hierarchical"))
    filterState = .init()
    hierarchicalInteractor = HierarchicalInteractor(hierarchicalAttributes: order, separator: " > ")
    tableViewController = .init(style: .plain)
    hierarchicalTableViewController = .init(tableView: tableViewController.tableView)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  func setup() {
    searcher.connectFilterState(filterState)
    hierarchicalInteractor.connectSearcher(searcher: searcher)
    hierarchicalInteractor.connectFilterState(filterState)
    hierarchicalInteractor.connectController(hierarchicalTableViewController)
    searcher.search()
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
