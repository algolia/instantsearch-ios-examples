//
//  HighlightingDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 17/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class HighlightingDemoViewController: UIViewController {
  
  typealias HitType = Hit<Movie>
  
  let stackView = UIStackView()
  let searchBar = UISearchBar()

  let searcher: SingleIndexSearcher

  let queryInputInteractor: QueryInputInteractor
  let textFieldController: TextFieldController
  
  let hitsInteractor: HitsInteractor<HitType>
  let hitsTableViewController: MovieHitsTableViewController<HitType>
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = SingleIndexSearcher(client: .demo, indexName: "mobile_demo_movies")
    self.queryInputInteractor = .init()
    self.textFieldController = .init(searchBar: searchBar)
    self.hitsInteractor = .init()
    self.hitsTableViewController = MovieHitsTableViewController()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
    
    queryInputInteractor.connectSearcher(searcher)
    queryInputInteractor.connectController(textFieldController)
        
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableViewController)
    
    searcher.search()
  }

  
}

private extension HighlightingDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    configureSearchBar()
    configureStackView()
    configureLayout()
  }
  
  func configureSearchBar() {
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
  }
  
  func configureStackView() {
    stackView.spacing = .px16
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureLayout() {
    
    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
    
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(hitsTableViewController.view)
    
    view.addSubview(stackView)
    
    stackView.pin(to: view.safeAreaLayoutGuide)
    
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
  }
  
}
