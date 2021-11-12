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
  
  let searchBar = UISearchBar()

  let searcher: HitsSearcher

  let queryInputConnector: QueryInputConnector
  let textFieldController: TextFieldController
  
  let hitsConnector: HitsConnector<HitType>
  let hitsTableViewController: MovieHitsTableViewController<HitType>
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_movies")
    self.textFieldController = .init(searchBar: searchBar)
    self.hitsTableViewController = MovieHitsTableViewController()
    queryInputConnector = .init(searcher: searcher, controller: textFieldController)
    hitsConnector = .init(searcher: searcher, interactor: .init(), controller: hitsTableViewController)
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
    hitsTableViewController.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: hitsTableViewController.cellIdentifier)
    searcher.search()
  }
  
}

private extension HighlightingDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
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
