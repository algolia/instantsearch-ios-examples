//
//  DemoListViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 26/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

typealias QuerySuggestionsDemoViewController = SearchViewController

class DemoListViewController: UIViewController {
  
  let searcher: HitsSearcher
  let filterState: FilterState
  let hitsInteractor: HitsInteractor<Demo>
  let textFieldController: TextFieldController
  let queryInputInteractor: QueryInputInteractor
  
  let tableView: UITableView
  let searchController: UISearchController
  private let cellIdentifier = "cellID"
  var groupedDemos: [(groupName: String, demos: [Demo])]
  weak var delegate: DemoListViewControllerDelegate?

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_home")
    filterState = .init()
    hitsInteractor = HitsInteractor(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true)
    groupedDemos = []
    
    searcher.request.query.hitsPerPage = 40
    searcher.connectFilterState(filterState)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectFilterState(filterState)
    searchController = UISearchController(searchResultsController: .none)
    textFieldController = TextFieldController(searchBar: searchController.searchBar)
    queryInputInteractor = .init()
    queryInputInteractor.connectController(textFieldController)
    queryInputInteractor.connectSearcher(searcher)
    searchController.obscuresBackgroundDuringPresentation = false
    self.tableView = UITableView()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    definesPresentationContext = true
    navigationItem.searchController = searchController
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.delegate = self
    tableView.dataSource = self
    hitsInteractor.onResultsUpdated.subscribe(with: self) { viewController, results in
      let demos = (try? results.extractHits() as [Demo]) ?? []
      viewController.updateDemos(demos)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    tableView.pin(to: view.safeAreaLayoutGuide)
    searcher.search()
  }
  
}

extension DemoListViewController: UITableViewDataSource {
  
  func updateDemos(_ demos: [Demo]) {
    let demosPerType = Dictionary(grouping: demos, by: { $0.type })
    self.groupedDemos = demosPerType
      .sorted { $0.key < $1.key }
      .map { ($0.key, $0.value.sorted { $0.name < $1.name } ) }
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return groupedDemos.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groupedDemos[section].demos.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let demo = groupedDemos[indexPath.section].demos[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    cell.textLabel?.text = demo.name
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return groupedDemos[section].groupName
  }
  
}

extension DemoListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let demo = groupedDemos[indexPath.section].demos[indexPath.row]
    delegate?.demoListViewController(self, didSelect: demo)
  }
  
}

protocol DemoListViewControllerDelegate: AnyObject {
  
  func demoListViewController(_ demoListViewController: DemoListViewController, didSelect demo: Demo)
  
}

