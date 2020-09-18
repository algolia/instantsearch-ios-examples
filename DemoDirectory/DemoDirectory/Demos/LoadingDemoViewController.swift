//
//  LoadingDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 25/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch
import SDWebImage

class LoadingDemoViewController: UIViewController {
  
  typealias HitType = Movie
  
  let stackView = UIStackView()
  let activityIndicator = UIActivityIndicatorView(style: .medium)
  
  let searcher: SingleIndexSearcher
  
  let searchBar: UISearchBar
  let queryInputConnector: QueryInputConnector<SingleIndexSearcher>
  let searchBarController: TextFieldController
  
  let statsConnector: StatsConnector
  let statsController: LabelStatsController
  
  let hitsConnector: HitsConnector<HitType>
  let hitsTableViewController: MovieHitsTableViewController<HitType>
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = SingleIndexSearcher(client: .demo, indexName: "mobile_demo_movies")
    self.searchBar = .init()
    self.searchBarController = .init(searchBar: searchBar)
    self.queryInputConnector = QueryInputConnector(searcher: searcher, controller: searchBarController)
    self.statsController = .init(label: .init())
    statsConnector = .init(searcher: searcher, controller: statsController, presenter: DefaultPresenter.Stats.present)
    self.hitsTableViewController = MovieHitsTableViewController()
    self.hitsConnector = .init(searcher: searcher, controller: hitsTableViewController)
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
    activityIndicator.hidesWhenStopped = true
    
    hitsTableViewController.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: hitsTableViewController.cellIdentifier)
        
    searcher.isLoading.subscribe(with: self) { viewController, isLoading in
      if isLoading {
        viewController.activityIndicator.startAnimating()
      } else {
        viewController.activityIndicator.stopAnimating()
      }
    }.onQueue(.main)
    
    searcher.search()
  }
  
}

private extension LoadingDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    configureSearchBar()
    configureStatsLabel()
    configureStackView()
    configureLayout()
  }
  
  func configureSearchBar() {
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
  }
  
  func configureStatsLabel() {
    statsController.label.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureStackView() {
    stackView.spacing = .px16
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureLayout() {
    
    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
    
    let barStackView = UIStackView()
    barStackView.axis = .horizontal
    barStackView.addArrangedSubview(searchBar)
    barStackView.addArrangedSubview(activityIndicator)
    let spacerView = UIView()
    spacerView.translatesAutoresizingMaskIntoConstraints = false
    spacerView.widthAnchor.constraint(equalToConstant: 4).isActive = true
    barStackView.addArrangedSubview(spacerView)
    stackView.addArrangedSubview(barStackView)
    let statsContainer = UIView()
    statsContainer.translatesAutoresizingMaskIntoConstraints = false
    statsContainer.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    statsContainer.addSubview(statsController.label)
    statsController.label.pin(to: statsContainer.layoutMarginsGuide)
    stackView.addArrangedSubview(statsContainer)
    stackView.addArrangedSubview(hitsTableViewController.view)
    
    view.addSubview(stackView)
    
    stackView.pin(to: view.safeAreaLayoutGuide)
    
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    statsController.label.heightAnchor.constraint(equalToConstant: 16).isActive = true
    
  }
  
}
