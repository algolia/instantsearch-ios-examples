//
//  SingleIndexDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 05/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import UIKit
import InstantSearchCore
import InstantSearch
import SDWebImage

class SingleIndexDemoViewController: UIViewController {
  
  typealias HitType = Movie
  
  let stackView = UIStackView()
  
  let searcher: SingleIndexSearcher
  
  let queryInputInteractor: QueryInputInteractor
  let searchBarController: SearchBarController
  
  let statsInteractor: StatsInteractor
  let statsController: LabelStatsController
  
  let hitsInteractor: HitsInteractor<HitType>
  let hitsTableViewController: HitsTableViewController<HitType>
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = SingleIndexSearcher(index: .demo(withName: "mobile_demo_movies"))
    self.queryInputInteractor = .init()
    self.searchBarController = .init(searchBar: .init())
    self.statsInteractor = .init()
    self.statsController = .init(label: .init())
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
    
    queryInputInteractor.connectSearcher(searcher, searchTriggeringMode: .searchAsYouType)
    queryInputInteractor.connectController(searchBarController)
    
    statsInteractor.connectSearcher(searcher)
    statsInteractor.connectController(statsController)
    
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableViewController)
    
    searcher.search()
  }

}

private extension SingleIndexDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    configureSearchBar()
    configureStatsLabel()
    configureStackView()
    configureLayout()
  }
  
  func configureSearchBar() {
    let searchBar = searchBarController.searchBar
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
    
    stackView.addArrangedSubview(searchBarController.searchBar)
    let statsContainer = UIView()
    statsContainer.translatesAutoresizingMaskIntoConstraints = false
    statsContainer.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    statsContainer.addSubview(statsController.label)
    statsController.label.pin(to: statsContainer.layoutMarginsGuide)
    stackView.addArrangedSubview(statsContainer)
    stackView.addArrangedSubview(hitsTableViewController.view)
    
    view.addSubview(stackView)

    stackView.pin(to: view.safeAreaLayoutGuide)
    
    searchBarController.searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true

    statsController.label.heightAnchor.constraint(equalToConstant: 16).isActive = true

  }
  
}

