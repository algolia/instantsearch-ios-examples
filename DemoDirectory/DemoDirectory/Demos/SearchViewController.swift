//
//  SearchViewController.swift
//  QuerySuggestions
//
//  Created by Vladislav Fitc on 27/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

public class SearchViewController: UIViewController {
  
  let appID: ApplicationID = "latency"
  let apiKey: APIKey = "afc3dd66dd1293e2e2736a5a51b05c0a"
  let suggestionsIndex: IndexName = "instantsearch_query_suggestions"
  let resultsIndex: IndexName = "instant_search"
  
  let searchController: UISearchController
  
  let queryInputInteractor: QueryInputInteractor
  let textFieldController: TextFieldController
    
  let suggestionsHitsInteractor: HitsInteractor<Hit<QuerySuggestion>>
  let suggestionsViewController: QuerySuggestionsViewController
  
  let resultsHitsInteractor: HitsInteractor<ShopItem>
  let resultsViewController: ResultsViewController
  
  let compositeSearcher: CompositeSearcher
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    
    suggestionsHitsInteractor = .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true)
    suggestionsViewController = .init(style: .plain)
    
    resultsHitsInteractor = .init(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true)
    resultsViewController = .init(style: .plain)
    
    searchController = .init(searchResultsController: suggestionsViewController)
        
    queryInputInteractor = .init()
    textFieldController = .init(searchBar: searchController.searchBar)
    
    compositeSearcher = .init(appID: appID, apiKey: apiKey)
    let suggestionsSearcher = compositeSearcher.addHitsSearcher(indexName: suggestionsIndex)
    let resultsSearchers = compositeSearcher.addHitsSearcher(indexName: resultsIndex)
    suggestionsHitsInteractor.connectSearcher(suggestionsSearcher)
    resultsHitsInteractor.connectSearcher(resultsSearchers)
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
      
  private func configureUI() {
    definesPresentationContext = true
    searchController.showsSearchResultsController = true
    view.backgroundColor = .white
    addChild(resultsViewController)
    resultsViewController.didMove(toParent: self)
    resultsViewController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(resultsViewController.view)
    NSLayoutConstraint.activate([
      resultsViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      resultsViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      resultsViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      resultsViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
  }
  
  private func setup() {
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    
    queryInputInteractor.connect(compositeSearcher)
    queryInputInteractor.connectController(textFieldController)
    queryInputInteractor.connectController(suggestionsViewController)
    
    queryInputInteractor.onQuerySubmitted.subscribe(with: searchController) { (searchController, _) in
      searchController.dismiss(animated: true, completion: .none)
    }
        
    suggestionsHitsInteractor.connectController(suggestionsViewController)
    resultsHitsInteractor.connectController(resultsViewController)
    
    suggestionsViewController.isHighlightingInverted = true
    compositeSearcher.search()
  }
  
}
