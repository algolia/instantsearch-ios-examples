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
  
  let stackView = UIStackView()
  let searcher: SingleIndexSearcher
  
  let queryInputInteractor: QueryInputInteractor
  let searchBarController: SearchBarController
  
  let hitsInteractor: HitsInteractor<HitType>
  let hitsTableViewController: HitsTableViewController<HitType>

  
  init(searchTriggeringMode: SearchTriggeringMode) {
    self.searchTriggeringMode = searchTriggeringMode
    self.searcher = SingleIndexSearcher(index: .demo(withName: "mobile_demo_movies"))
    self.searchBarController = .init(searchBar: .init())
    self.queryInputInteractor = .init()
    self.hitsInteractor = .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true)
    self.hitsTableViewController = HitsTableViewController()
    super.init(nibName: .none, bundle: .none)
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
    
    queryInputInteractor.connectController(searchBarController)
    queryInputInteractor.connectSearcher(searcher, searchTriggeringMode: searchTriggeringMode)
    
    searcher.search()
    
  }
  
}

private extension SearchInputDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    configureSearchBar()
    configureStackView()
    configureLayout()
  }
  
  func configureSearchBar() {
    let searchBar = searchBarController.searchBar
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
  }
  
  func configureStackView() {
    stackView.spacing = .px16
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureLayout() {
    
    searchBarController.searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
    
    stackView.addArrangedSubview(searchBarController.searchBar)
    stackView.addArrangedSubview(hitsTableViewController.view)
    
    view.addSubview(stackView)
    
    stackView.pin(to: view.safeAreaLayoutGuide)
    
  }
  
}




