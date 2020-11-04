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
  
  let activityIndicator = UIActivityIndicatorView(style: .medium)
  
  let searcher: SingleIndexSearcher
  
  let searchBar: UISearchBar
  let queryInputConnector: QueryInputConnector
  let searchBarController: TextFieldController
  
  let loadingConnector: LoadingConnector
  let loadingController: ActivityIndicatorController
  
  let statsConnector: StatsConnector
  let statsController: LabelStatsController
  
  let hitsConnector: HitsConnector<HitType>
  let hitsTableViewController: MovieHitsTableViewController<HitType>
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = SingleIndexSearcher(client: .demo, indexName: "mobile_demo_movies")
    searchBar = .init()
    searchBarController = .init(searchBar: searchBar)
    queryInputConnector = QueryInputConnector(searcher: searcher, controller: searchBarController)
    statsController = .init(label: .init())
    loadingController = .init(activityIndicator: activityIndicator)
    loadingConnector = .init(searcher: searcher, controller: loadingController)
    statsConnector = .init(searcher: searcher, controller: statsController, presenter: DefaultPresenter.Stats.present)
    hitsTableViewController = MovieHitsTableViewController()
    hitsConnector = .init(searcher: searcher, controller: hitsTableViewController)
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
    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
    activityIndicator.hidesWhenStopped = true
    hitsTableViewController.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: hitsTableViewController.cellIdentifier)
    searcher.search()
  }
  
}

private extension LoadingDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    statsController.label.translatesAutoresizingMaskIntoConstraints = false
    
    let barStackView = UIStackView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.axis, to: .horizontal)
    barStackView.addArrangedSubview(searchBar)
    barStackView.addArrangedSubview(activityIndicator)
    
    let statsContainer = UIView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.layoutMargins, to: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    statsContainer.addSubview(statsController.label)
    statsController.label.pin(to: statsContainer.layoutMarginsGuide)
    
    let stackView = UIStackView()
      .set(\.spacing, to: .px16)
      .set(\.axis, to: .vertical)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
    stackView.addArrangedSubview(barStackView)
    stackView.addArrangedSubview(statsContainer)
    stackView.addArrangedSubview(hitsTableViewController.view)
    
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide)
  }

}
