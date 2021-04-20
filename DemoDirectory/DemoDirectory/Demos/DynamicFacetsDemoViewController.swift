//
//  DynamicFacetsDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 04/03/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class DynamicFacetsDemoViewController: UIViewController {
  
  let searchBar: UISearchTextField
  let hintLabel: UILabel

  let searcher: SingleIndexSearcher
  let queryInputConnector: QueryInputConnector
  let dynamicFacetsInteractor: DynamicFacetsInteractor
  let textFieldController: TextFieldController
  let facetsTableViewController: DynamicFacetsTableViewController
  let filterState: FilterState
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = .init(client: .demo, indexName: "mobile_demo_dynamic_facets")
    searchBar = .init()
    textFieldController = TextFieldController(textField: searchBar)
    queryInputConnector = .init(searcher: searcher, controller: textFieldController)
    dynamicFacetsInteractor = .init(facetOrder: .init(), selections: [:])
    facetsTableViewController = .init()
    filterState = .init()
    hintLabel = .init()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    addChild(facetsTableViewController)
    facetsTableViewController.didMove(toParent: self)
    super.viewDidLoad()
    setupUI()
    
    searcher.indexQueryState.query.facets = ["brand", "color", "size", "country"]
    searcher.onResults.subscribe(with: self) { (controller, searchResponse) in
      let isEmptyFacetOrder = searchResponse.rules?.consequence?.renderingContent?.facetMerchandising?.facetOrdering.facetValues.isEmpty ?? true
      controller.hintLabel.isHidden = !isEmptyFacetOrder
      controller.facetsTableViewController.view.isHidden = isEmptyFacetOrder
    }.onQueue(.main)
    
    dynamicFacetsInteractor.connectSearcher(searcher)
    dynamicFacetsInteractor.connectFilterState(filterState)
    dynamicFacetsInteractor.connectController(facetsTableViewController)
    searcher.search()
  }
  
  private func setupUI() {
    view.backgroundColor = .systemBackground
    
    hintLabel.translatesAutoresizingMaskIntoConstraints = false
    hintLabel.textAlignment = .center
    hintLabel.text = "Type \"a\", \"ab\" or \"abc\" to trigger a rule"
    
    facetsTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
    
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.setContentHuggingPriority(.defaultHigh, for: .vertical)

    let searchBarContainer = UIView()
    searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
    searchBarContainer.addSubview(searchBar)
    searchBar.pin(to: searchBarContainer, insets: .init(top: 5, left: 5, bottom: -5, right: -5))
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.addArrangedSubview(searchBarContainer)
    stackView.addArrangedSubview(facetsTableViewController.view)
    stackView.addArrangedSubview(hintLabel)
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
  
}
