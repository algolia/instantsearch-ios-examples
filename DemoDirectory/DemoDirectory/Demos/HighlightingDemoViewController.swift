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

  let searcher: SingleIndexSearcher

  let queryInputInteractor: QueryInputInteractor
  let searchBarController: SearchBarController
  
  let hitsInteractor: HitsInteractor<HitType>
  let hitsTableViewController: HitsTableViewController<HitType>
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = SingleIndexSearcher(index: .demo(withName: "mobile_demo_movies"))
    self.queryInputInteractor = .init()
    self.searchBarController = .init(searchBar: .init())
    self.hitsInteractor = .init()
    self.hitsTableViewController = HitsTableViewController()
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
    queryInputInteractor.connectController(searchBarController)
        
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
    
    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
    
    stackView.addArrangedSubview(searchBarController.searchBar)
    stackView.addArrangedSubview(hitsTableViewController.view)
    
    view.addSubview(stackView)
    
    stackView.pin(to: view.safeAreaLayoutGuide)
    
    searchBarController.searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
  }
  
}
