//
//  MultiIndexHitsConnectorSearchViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class MultiIndexHitsConnectorSearchViewController: UIViewController {
  
  let searchBar: UISearchBar
  let textFieldController: TextFieldController
  let queryInputConnector: QueryInputConnector<MultiIndexSearcher>

  let hitsConnector: MultiIndexHitsConnector
  let hitsViewController: MultiIndexWidgetHitsViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    // Instantiate ViewControllers
    searchBar = UISearchBar()
    hitsViewController = MultiIndexWidgetHitsViewController()
    textFieldController = TextFieldController(searchBar: searchBar)
    
    // Instantiate connectors
    hitsConnector = MultiIndexHitsConnector(appID: "latency",
                                            apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                            indexModules: [
                                              .init(indexName: "mobile_demo_actors", hitType: Actor.self),
                                              .init(indexName: "mobile_demo_movies", hitType: Movie.self),
    ])
    queryInputConnector = QueryInputConnector(searcher: hitsConnector.searcher)
    
    // Connect view controllers
    hitsConnector.interactor.connectController(hitsViewController)
    queryInputConnector.interactor.connectController(textFieldController)
    
    hitsConnector.searcher.search()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  func configureUI() {
    view.backgroundColor = .white
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 16
    stackView.axis = .vertical
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    stackView.isLayoutMarginsRelativeArrangement = true
    
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    searchBar.searchBarStyle = .minimal
    
    stackView.addArrangedSubview(searchBar)
    
    hitsViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(hitsViewController.tableView)
    
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])

  }

}


extension MultiIndexHitsConnector.IndexModule {
  
  init<Hit: Codable>(indexName: IndexName, hitType: Hit.Type, infiniteScrolling: InfiniteScrolling = .off, filterState: FilterState? = nil) {
    let hitsInteractor = HitsInteractor<Hit>(infiniteScrolling: infiniteScrolling)
    self.init(indexName: indexName, hitsInteractor: hitsInteractor, filterState: filterState)
  }
  
}
