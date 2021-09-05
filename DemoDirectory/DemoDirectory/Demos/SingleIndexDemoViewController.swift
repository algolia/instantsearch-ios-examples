//
//  SingleIndexDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 05/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import UIKit
import InstantSearch
import SDWebImage

class SingleIndexDemoViewController: UIViewController {
  
  typealias HitType = ShopItem
  
  let searchBar = UISearchBar()
  
  let searcher: HitsSearcher
  
  let queryInputConnector: QueryInputConnector
  let textFieldController: TextFieldController
  
  let statsConnector: StatsConnector
  let statsController: LabelStatsController
  
  let hitsConnector: HitsConnector<HitType>
  let hitsTableViewController: ResultsTableViewController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = HitsSearcher(client: .demo, indexName: "instant_search")
    textFieldController = .init(searchBar: searchBar)
    queryInputConnector = .init(searcher: searcher, controller: textFieldController)

    statsController = .init()
    statsConnector = .init(searcher: searcher, controller: statsController)

    hitsTableViewController = ResultsTableViewController()
    hitsConnector = .init(searcher: searcher,
                          interactor: .init(),
                          controller: hitsTableViewController)

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
    hitsTableViewController.tableView.keyboardDismissMode = .onDrag
    searcher.search()
  }

}

private extension SingleIndexDemoViewController {
  
  func configureUI() {
    title = "Amazing"
    view.backgroundColor = .white

    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
    
    let stackView = UIStackView()
      .set(\.spacing, to: .px16)
      .set(\.axis, to: .vertical)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
    stackView.addArrangedSubview(searchBar)
    let statsContainer = UIView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.layoutMargins, to: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    statsContainer.addSubview(statsController.label)
    statsController.label.translatesAutoresizingMaskIntoConstraints = false
    statsController.label.pin(to: statsContainer.layoutMarginsGuide)
    stackView.addArrangedSubview(statsContainer)
    stackView.addArrangedSubview(hitsTableViewController.view)
    
    view.addSubview(stackView)

    stackView.pin(to: view.safeAreaLayoutGuide)
  }
    
}
