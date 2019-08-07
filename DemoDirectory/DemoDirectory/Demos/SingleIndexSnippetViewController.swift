//
//  SingleIndexSnippet.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 05/03/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import UIKit
import InstantSearch

class SingleIndexSnippetViewController: UIViewController {
  
  let searcher: SingleIndexSearcher = .init(appID: "latency",
                                            apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                            indexName: "bestbuy")
  
  let queryInputInteractor: QueryInputInteractor = .init()
  let searchBarController: SearchBarController = .init(searchBar: UISearchBar())
  
  let statsInteractor: StatsInteractor = .init()
  let statsController: LabelStatsController = .init(label: UILabel())
  
  let hitsInteractor: HitsInteractor<JSON> = .init()
  let hitsTableController: HitsTableController<HitsInteractor<JSON>> = .init(tableView: UITableView())
  
  let categoryAttribute: Attribute = "category"
  let filterState: FilterState = .init()
  
  let categoryInteractor: FacetListInteractor = .init(selectionMode: .single)
  let categoryTableViewController: UITableViewController = .init()
  lazy var categoryListController: FacetListTableController = {
    return .init(tableView: categoryTableViewController.tableView, titleDescriptor: .none)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    configureUI()
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  func setup() {
    
    searcher.connectFilterState(filterState)
    
    queryInputInteractor.connectSearcher(searcher)
    queryInputInteractor.connectController(searchBarController)
    
    statsInteractor.connectSearcher(searcher)
    statsInteractor.connectController(statsController)
    
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableController)
    hitsInteractor.connectFilterState(filterState)

    hitsTableController.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    hitsTableController.dataSource = .init(cellConfigurator: { tableView, hit, indexPath in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
      cell.textLabel?.text = [String: Any](hit)?["name"] as? String
      return cell
    })
    
    categoryInteractor.connectSearcher(searcher, with: categoryAttribute)
    categoryInteractor.connectFilterState(filterState, with: categoryAttribute, operator: .and)
    categoryInteractor.connectController(categoryListController, with: FacetListPresenter(sortBy: [.isRefined]))
    
    searcher.search()
  }
  
  func configureUI() {
  
    view.backgroundColor = .white
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 16
    stackView.axis = .vertical
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    stackView.isLayoutMarginsRelativeArrangement = true
    
    let searchBar = searchBarController.searchBar
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    searchBar.searchBarStyle = .minimal
    
    let filterButton = UIButton()
    filterButton.setTitleColor(.black, for: .normal)
    filterButton.setTitle("Filter", for: .normal)
    filterButton.addTarget(self, action: #selector(showFilters), for: .touchUpInside)
    
    let searchBarFilterButtonStackView = UIStackView()
    searchBarFilterButtonStackView.translatesAutoresizingMaskIntoConstraints = false
    searchBarFilterButtonStackView.spacing = 4
    searchBarFilterButtonStackView.axis = .horizontal
    searchBarFilterButtonStackView.addArrangedSubview(searchBar)
    searchBarFilterButtonStackView.addArrangedSubview(filterButton)
    let spacer = UIView()
    spacer.widthAnchor.constraint(equalToConstant: 4).isActive = true
    searchBarFilterButtonStackView.addArrangedSubview(spacer)
    
    stackView.addArrangedSubview(searchBarFilterButtonStackView)
    
    let statsLabel = statsController.label
    statsLabel.translatesAutoresizingMaskIntoConstraints = false
    statsLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    stackView.addArrangedSubview(statsLabel)

    stackView.addArrangedSubview(hitsTableController.tableView)
    
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      ])
    
    categoryTableViewController.title = "Category"
    categoryTableViewController.view.backgroundColor = .white
    
  }
  
  @objc func showFilters() {
    let navigationController = UINavigationController(rootViewController: categoryTableViewController)
    categoryTableViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissFilters))
    present(navigationController, animated: true, completion: .none)
  }
  
  @objc func dismissFilters() {
    dismiss(animated: true, completion: .none)
  }
  
}
