//
//  ViewController.swift
//  IS-CustomSource
//
//  Created by Robert Mogos on 06/10/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore

class ViewController: UIViewController, HitsTableViewDataSource {

  var hitsController: HitsController!
  var instantSearch: InstantSearch!
  var searchBar: SearchBarWidget!
  
  lazy var tableView: HitsTableWidget = {
    HitsTableWidget(frame: .zero, style: .plain)
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar = SearchBarWidget(frame: .zero)
    
    self.navigationItem.titleView = searchBar
    self.edgesForExtendedLayout = []
    tableView.frame = self.view.frame
    self.view.addSubview(tableView)
    hitsController = HitsController(table: tableView)
    tableView.dataSource = hitsController
    tableView.delegate = hitsController
    hitsController.tableDataSource = self
    tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cellID")
    configureInstantSearch()
  }
  
  func configureInstantSearch() {
    
    // Initialising an Index
    
    // With POC 1
    //let index = CustomSearchableImplementation()
    
    // With POC 2
    let index = CustomSearchable(searchTransformer: CustomSearchTransformerImplementation())
    
    
    let searcher = Searcher(index: index)
    instantSearch = InstantSearch.init(searcher: searcher)
    instantSearch.registerAllWidgets(in: self.view)
    instantSearch.register(widget: searchBar)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, containing hit: [String: Any]) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
    cell.textLabel?.text = hit["nameCustom"] as? String
    return cell
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

