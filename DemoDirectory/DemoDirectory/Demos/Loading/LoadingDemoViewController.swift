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
  
  let controller: LoadingDemoController

  let activityIndicator = UIActivityIndicatorView(style: .medium)
  
  let searchBar: UISearchBar
  
  let searchBarController: TextFieldController
  
  let loadingController: ActivityIndicatorController
  
  let statsController: LabelStatsController
  
  let hitsTableViewController: MovieHitsTableViewController<HitType>
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchBar = .init()
    searchBarController = .init(searchBar: searchBar)
    statsController = .init(label: .init())
    loadingController = .init(activityIndicator: activityIndicator)
    hitsTableViewController = MovieHitsTableViewController()
    self.controller = .init(queryInputController: searchBarController,
                            loadingController: loadingController,
                            statsController: statsController,
                            hitsController: hitsTableViewController)
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
