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
  
  typealias HitType = Movie
  
  let searchTriggeringMode: SearchTriggeringMode
  
  let searcher: SingleIndexSearcher
  
  let queryInputConnector: QueryInputConnector<SingleIndexSearcher>
  
  let hitsInteractor: HitsInteractor<HitType>

  let searchBar: UISearchBar
  let textFieldController: TextFieldController
  let hitsTableViewController: MovieHitsTableViewController<HitType>
  
  init(searchTriggeringMode: SearchTriggeringMode) {
    self.searchBar = .init()
    self.searchTriggeringMode = searchTriggeringMode
    self.searcher = SingleIndexSearcher(client: .demo, indexName: "mobile_demo_movies")
    self.textFieldController = .init(searchBar: searchBar)
    self.queryInputConnector = QueryInputConnector(searcher: searcher,
                                                   searchTriggeringMode: searchTriggeringMode,
                                                   controller: textFieldController)
    self.hitsInteractor = .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true)
    self.hitsTableViewController = MovieHitsTableViewController()
    super.init(nibName: .none, bundle: .none)
    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  private func setup() {
    hitsTableViewController.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: hitsTableViewController.cellIdentifier)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableViewController)
    searcher.search()
  }
  
}

private extension SearchInputDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    searchBar
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.searchBarStyle, to: .minimal)
    let stackView = UIStackView()
      .set(\.spacing, to: .px16)
      .set(\.axis, to: .vertical)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(hitsTableViewController.view)
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide)
  }
    
}
