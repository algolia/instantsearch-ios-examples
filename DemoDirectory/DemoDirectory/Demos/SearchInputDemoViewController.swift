//
//  SearchInputDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class SearchInputDemoViewController: UIViewController {
  
  let searcher: HitsSearcher
  
  let hitsInteractor: HitsInteractor<Hit<StoreItem>>
  
  let searchController: UISearchController
  let textFieldController: TextFieldController
  let statsConnector: StatsConnector
  let queryInputConnector: QueryInputConnector
  let loadingConnector: LoadingConnector
  let resultsViewController: ResultsViewController
  
  init(searchTriggeringMode: SearchTriggeringMode) {
    searcher = .init(client: .newDemo,
                     indexName: Index.Ecommerce.products)
    resultsViewController = .init()
    searchController = .init(searchResultsController: resultsViewController)
    textFieldController = .init(searchBar: searchController.searchBar)
    queryInputConnector = .init(searcher: searcher,
                                searchTriggeringMode: searchTriggeringMode,
                                controller: textFieldController)
    statsConnector = .init(searcher: searcher,
                           controller: resultsViewController.statsController)
    hitsInteractor = .init()
    loadingConnector = .init(searcher: searcher,
                             controller: resultsViewController.loadingController)
    super.init(nibName: .none, bundle: .none)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }
  
  private func setupUI() {
    title = "Search"
    view.backgroundColor = .white
    definesPresentationContext = true
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }
  
  private func setup() {
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(resultsViewController.hitsViewController)
    searcher.search()
  }
  
}
