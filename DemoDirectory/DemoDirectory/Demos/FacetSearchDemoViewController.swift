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

  let searcher: SingleIndexSearcher
  let filterState: FilterState
  let facetSearcher: FacetSearcher
  let searchBar: UISearchBar
  let textFieldController: TextFieldController
  let categoryController: FacetListTableController
  let categoryListInteractor: FacetListInteractor
  let searchStateViewController: SearchStateViewController
  
  let queryInputInteractor: QueryInputInteractor
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
    let indexName: IndexName = "mobile_demo_facet_list_search"
    searcher = SingleIndexSearcher(client: .demo, indexName: indexName)
    filterState = .init()
    facetSearcher = FacetSearcher(client: .demo, indexName: indexName, facetName: "brand")
    
    queryInputInteractor = QueryInputInteractor()
    categoryListInteractor = FacetListInteractor(selectionMode: .multiple)

    searchBar = .init()
    textFieldController = TextFieldController(searchBar: searchBar)
    searchStateViewController = SearchStateViewController()
    categoryController = FacetListTableController(tableView: .init())

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
    
    searcher.search()
    searcher.connectFilterState(filterState)

    facetSearcher.search()
    facetSearcher.connectFilterState(filterState)

    searchStateViewController.connectSearcher(searcher)
    searchStateViewController.connectFilterState(filterState)
    searchStateViewController.connectFacetSearcher(facetSearcher)

    queryInputInteractor.connectController(textFieldController)
    queryInputInteractor.connectSearcher(facetSearcher)
    
    categoryListInteractor.connectFacetSearcher(facetSearcher)
    categoryListInteractor.connectFilterState(filterState, with: Attribute("brand"), operator: .or)
    categoryListInteractor.connectController(categoryController)
    
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

