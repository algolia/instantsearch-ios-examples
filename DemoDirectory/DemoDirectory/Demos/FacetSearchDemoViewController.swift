//
//  FacetSearchDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 22/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class FacetSearchDemoViewController: UIViewController {

  let filterState: FilterState
  let facetSearcher: FacetSearcher
  let searchBar: UISearchBar
  let textFieldController: TextFieldController
  let categoryController: FacetListTableController
  let categoryListConnector: FacetListConnector
  let queryInputConnector: QueryInputConnector<FacetSearcher>
  
  let searchStateViewController: SearchStateViewController

  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
    filterState = .init()
    facetSearcher = FacetSearcher(client: .demo, indexName: "mobile_demo_facet_list_search", facetName: "brand")
    
    categoryController = FacetListTableController(tableView: .init())
    categoryListConnector = .init(searcher: facetSearcher,
                                  filterState: filterState,
                                  attribute: "brand",
                                  operator: .or,
                                  controller: categoryController)

    searchBar = .init()
    textFieldController = TextFieldController(searchBar: searchBar)
    queryInputConnector = QueryInputConnector(searcher: facetSearcher, controller: textFieldController)
    
    searchStateViewController = SearchStateViewController()
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    setup()


  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

private extension FacetSearchDemoViewController {
  
  func setup() {
    
//    searcher.search()
//    searcher.connectFilterState(filterState)

    facetSearcher.search()
    facetSearcher.connectFilterState(filterState)

    searchStateViewController.connectFilterState(filterState)
    searchStateViewController.connectFacetSearcher(facetSearcher)
  }

  func setupUI() {
    
    view.backgroundColor = .white
    
    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = .px16
    
    view.addSubview(mainStackView)
    
    mainStackView.pin(to: view.safeAreaLayoutGuide)
    
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
    mainStackView.addArrangedSubview(searchBar)
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true

    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    mainStackView.addArrangedSubview(searchStateViewController.view)

    let tableView = categoryController.tableView
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    tableView.translatesAutoresizingMaskIntoConstraints = false

    mainStackView.addArrangedSubview(tableView)
    
  }

}

