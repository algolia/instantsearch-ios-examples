//
//  SearchConnectorSearchViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class SearchConnectorSearchViewController: UIViewController {
    
  let searchController: UISearchController
  let searchConnector: SearchConnector<Item>
  let hitsTableViewController: SearchResultsViewController
//  let statsInteractor: StatsInteractor
    
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    hitsTableViewController = .init(style: .plain)
    searchController = .init(searchResultsController: hitsTableViewController)
//    statsInteractor = .init()
    searchConnector = SearchConnector(appID: "latency",
                          apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                          indexName: "bestbuy",
                          searchController: searchController,
                          hitsInteractor: .init(),
                          hitsController: hitsTableViewController)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    statsInteractor.connectController(self)
//    if let singleIndexSearcher = searchConnector.hitsConnector.searcher as? SingleIndexSearcher {
//      statsInteractor.connectSearcher(singleIndexSearcher)
//    }
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    searchController.isActive = true
  }
  
  func setupUI() {
    view.backgroundColor = .white
    navigationItem.searchController = searchController
    navigationItem.largeTitleDisplayMode = .never
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }
  
}

extension SearchConnectorSearchViewController: StatsTextController {
  
  func setItem(_ item: String?) {
    searchController.searchBar.scopeButtonTitles = item.flatMap { [$0] }
  }
  
}
