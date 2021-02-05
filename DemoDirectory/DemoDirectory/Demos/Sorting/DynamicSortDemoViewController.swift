//
//  DynamicSortDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 04/02/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class DynamicSortToggleView: UIView, DynamicSortToggleController {
  
  let hintLabel: UILabel
  let toggleButton: UIButton
  
  var didToggle: (() -> Void)?
  
  override init(frame: CGRect) {
    hintLabel = .init()
    toggleButton = .init()
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setItem(_ item: (hint: String, buttonTitle: String)) {
    hintLabel.text = item.hint
    toggleButton.setTitle(item.buttonTitle, for: .normal)
  }
  
  @objc func didTapToggleButton(_ button: UIButton) {
    didToggle?()
  }
  
  func setupUI() {
    setupHintLabel()
    setupToggleButton()
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.spacing = 5
    stackView.distribution = .fill
    stackView.alignment = .center
    stackView.addArrangedSubview(hintLabel)
    stackView.addArrangedSubview(toggleButton)
    addSubview(stackView)
    stackView.pin(to: self, insets: .init(top: 3, left: 3, bottom: -3, right: -3))
  }
  
  func setupToggleButton() {
    toggleButton.translatesAutoresizingMaskIntoConstraints = false
    toggleButton.layer.borderWidth = 1
    toggleButton.layer.cornerRadius = 10
    toggleButton.layer.borderColor = tintColor.cgColor
    toggleButton.setTitleColor(self.tintColor, for: .normal)
    toggleButton.titleLabel?.font = .systemFont(ofSize: 10)
    toggleButton.addTarget(self, action: #selector(didTapToggleButton), for: .touchUpInside)
    toggleButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
    toggleButton.titleEdgeInsets = .init(top: 0, left: 3, bottom: 0, right: 3)
  }
  
  func setupHintLabel() {
    hintLabel.translatesAutoresizingMaskIntoConstraints = false
    hintLabel.font = .systemFont(ofSize: 12)
    hintLabel.numberOfLines = 0
  }
  
}

extension DynamicSortPriority {
  
  var hintText: String {
    switch self {
    case .hitsCount:
      return "Currently showing all results."
    case .relevancy:
      return "We removed some search results to show you the most relevants ones."
    }
  }
  
  var buttonTitle: String {
    switch self {
    case .hitsCount:
      return "Show more relevant results"
    case .relevancy:
      return "Show all results"
    }
  }
  
}


extension DynamicSortToggleInteractor {
  
//  struct SearcherConnection {
//
//  }
  
}




class DynamicSortDemoViewController: UIViewController {
  
  typealias HitType = ShopItem
  
  let indices: [IndexName] = [
    "test_Bestbuy",
    "test_Bestbuy_vr_price_asc", //smart sort
    "test_Bestbuy_replica_price_asc", //replica
  ]
  
  private let cellIdentifier = "CellID"
  
  let searchBar: UISearchBar
  
  let searcher = SingleIndexSearcher(appID: "C7RIRJRYR9", apiKey: "77af6d5ffb27caa5ff4937099fcb92e8", indexName: "test_Bestbuy_vr_price_asc")
  
  let queryInputConnector: QueryInputConnector
  let textFieldController: TextFieldController
  
  let hitsConnector: HitsConnector<HitType>
  let hitsTableViewController: ResultsTableViewController

  let mainStackView = UIStackView(frame: .zero)
  
  let statsLabel: UILabel
  let sortToggleView: DynamicSortToggleView
  var dynamicSortToggleInteractor: DynamicSortToggleInteractor
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchBar = .init()
    statsLabel = .init()
    sortToggleView = .init()
    dynamicSortToggleInteractor = .init()
    textFieldController = .init(searchBar: searchBar)
    queryInputConnector = .init(searcher: searcher, controller: textFieldController)

    hitsTableViewController = ResultsTableViewController()
    hitsConnector = .init(searcher: searcher, controller: hitsTableViewController)

    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    dynamicSortToggleInteractor.connectController(sortToggleView) { priority in
      return (priority.hintText, priority.buttonTitle)
    }
    
    dynamicSortToggleInteractor.onItemChanged.subscribe(with: searcher) { (searcher, priority) in
      searcher.indexQueryState.query.relevancyStrictness = self.dynamicSortToggleInteractor.relevancyStrictness(for: priority)
      searcher.search()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    searcher.search()
    sortToggleView.isHidden = true
    dynamicSortToggleInteractor.item = .relevancy
  }
    
  func setupUI() {
    title = "Amazing"
    view.backgroundColor = .white

    searcher.onResults.subscribe(with: self) { (controller, response) in
      controller.statsLabel.text = "nb hits: \(response.nbHits ?? 0), nb sorted hits: \(response.nbSortedHits ?? 0)"
      controller.sortToggleView.isHidden = response.nbHits == response.nbSortedHits
    }.onQueue(.main)
    
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
    
    let stackView = UIStackView()
      .set(\.spacing, to: .px16)
      .set(\.axis, to: .vertical)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
    stackView.addArrangedSubview(searchBar)
    statsLabel.translatesAutoresizingMaskIntoConstraints = false
    statsLabel.numberOfLines = 0
    stackView.addArrangedSubview(statsLabel)
    sortToggleView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(sortToggleView)
    stackView.addArrangedSubview(hitsTableViewController.view)
    
    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
  
  func configureMainStackView() {
    mainStackView.axis = .vertical
    mainStackView.spacing = .px16
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.alignment = .center
  }
  
}
