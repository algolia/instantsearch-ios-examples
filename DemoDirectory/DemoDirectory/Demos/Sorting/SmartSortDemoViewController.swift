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

class SmartSortDemoViewController: UIViewController, SelectableSegmentController {
    
  typealias HitType = ShopItem
  
  let indices: [IndexName] = [
    "test_Bestbuy", // default
    "test_Bestbuy_vr_price_asc", //smart sort
    "test_Bestbuy_replica_price_asc", //replica
  ]
  
  private let cellIdentifier = "CellID"
  
  let searchBar: UISearchBar
  
  let searcher: SingleIndexSearcher
  
  let queryInputConnector: QueryInputConnector
  let textFieldController: TextFieldController
  
  let hitsConnector: HitsConnector<HitType>
  let hitsTableViewController: ResultsTableViewController
  
  let statsConnector: StatsConnector
  let statsController: LabelStatsController
  
  let mainStackView = UIStackView(frame: .zero)
  
  let smartSortToggleView: SmartSortToggleControl
  let smartSortConnector: SmartSortConnector
  
  let indexSegmentInteractor: IndexSegmentInteractor
  let indexSegmentControl: UISegmentedControl
  var onClick: ((Int) -> Void)?
  
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = .init(appID: "C7RIRJRYR9", apiKey: "77af6d5ffb27caa5ff4937099fcb92e8", indexName: "test_Bestbuy_vr_price_asc")
    searchBar = .init()
    smartSortToggleView = .init()
    statsController = .init()
    statsConnector = .init(searcher: searcher, controller: statsController)
    smartSortConnector = .init(searcher: searcher, controller: smartSortToggleView)
    textFieldController = .init(searchBar: searchBar)
    queryInputConnector = .init(searcher: searcher, controller: textFieldController)

    hitsTableViewController = ResultsTableViewController()
    hitsConnector = .init(searcher: searcher, controller: hitsTableViewController)
    
    let items: [Int: Index] = .init(uniqueKeysWithValues: indices.map(searcher.client.index(withName:)).enumerated().map { ($0.offset, $0.element) })
    indexSegmentInteractor = .init(items: items, selected: 0)
    indexSegmentControl = .init()

    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    indexSegmentControl.addTarget(self, action: #selector(didSelectSegment), for: .valueChanged)
    indexSegmentInteractor.connectController(self) { index in
      switch index.name {
      case "test_Bestbuy": return "Most relevant"
      case "test_Bestbuy_vr_price_asc": return "Smart: price 🔼"
      case "test_Bestbuy_replica_price_asc": return "Hard: price 🔼"
      default: return ""
      }
    }
    indexSegmentInteractor.connectSearcher(searcher: searcher)
  }
  
  @objc func didSelectSegment(_ segmentedControl: UISegmentedControl) {
    onClick?(segmentedControl.selectedSegmentIndex)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    searcher.search()
  }
    
  func setupUI() {
    title = "Amazing"
    view.backgroundColor = .white
    
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
    
    let stackView = UIStackView()
      .set(\.spacing, to: .px16)
      .set(\.axis, to: .vertical)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
    stackView.addArrangedSubview(searchBar)
    indexSegmentControl.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(indexSegmentControl)
    statsController.label.translatesAutoresizingMaskIntoConstraints = false
    statsController.label.numberOfLines = 0
    statsController.label.textAlignment = .center
    stackView.addArrangedSubview(statsController.label)
    smartSortToggleView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(smartSortToggleView)
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
  
  func setSelected(_ selected: Int?) {
    indexSegmentControl.selectedSegmentIndex = selected ?? 0
  }
  
  func setItems(items: [Int : String]) {
    indexSegmentControl.removeAllSegments()
    items.forEach { indexSegmentControl.insertSegment(withTitle: $0.value, at: $0.key, animated: false) }
  }
  
}
