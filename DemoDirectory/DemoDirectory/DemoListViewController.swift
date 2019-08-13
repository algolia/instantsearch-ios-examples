//
//  DemoListViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 26/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore
import InstantSearch

struct Demo: Codable {
  
  let objectID: String
  let name: String
  let type: String
  let index: String
  
  enum ID: String {
    case singleIndex = "paging_single_index"
    case multiIndex = "paging_multiple_index"
    case sffv = "facet_list_search"
    case toggle = "filter_toggle"
    case toggleDefault = "filter_toggle_default"
    case facetList = "facet_list"
    case facetListPersistentSelection = "facet_list_persistent"
    case segmented = "filter_segment"
//    case allFilterList = "filter_list_all"
    case facetFilterList = "filter_list_facet"
    case numericFilterList = "filter_list_numeric"
    case tagFilterList = "filter_list_tag"
    case filterNumericComparison = "filter_numeric_comparison"
    case sortBy = "sort_by"
    case currentFilters = "filter_current"
    case searchAsYouType = "search_as_you_type"
    case searchOnSubmit = "search_on_submit"
    case clearFilters = "filter_clear"
    case filterNumericRange = "filter_numeric_range"
    case stats
    case highlighting
    case loading
    case hierarchical = "filter_hierarchical"
  }
  
}


class DemoListViewController: UIViewController {
  
  let searcher: SingleIndexSearcher
  let filterState: FilterState
  let hitsInteractor: HitsInteractor<Demo>
  let searchBarController: SearchBarController
  
  let tableView: UITableView
  let searchController: UISearchController
  private let cellIdentifier = "cellID"
  var groupedDemos: [(groupName: String, demos: [Demo])]

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = SingleIndexSearcher(index: .demo(withName: "mobile_demo_home"))
    filterState = .init()
    hitsInteractor = HitsInteractor(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true)
    searchBarController = SearchBarController(searchBar: .init())
    groupedDemos = []
    
    searcher.indexQueryState.query.hitsPerPage = 40
    searcher.connectFilterState(filterState)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectFilterState(filterState)
    searchController = UISearchController(searchResultsController: .none)
    searchController.dimsBackgroundDuringPresentation = false
    self.tableView = UITableView()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    definesPresentationContext = true
    searchController.searchResultsUpdater = self
    navigationItem.searchController = searchController
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.delegate = self
    tableView.dataSource = self
    hitsInteractor.onResultsUpdated.subscribe(with: self) { viewController, results in
      let demos = (try? results.deserializeHits() as [Demo]) ?? []
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
  
  func viewController(for index: Demo.ID) -> UIViewController {
    let viewController: UIViewController
    
    switch index {
    case .singleIndex:
      viewController = SingleIndexDemoViewController()
      
    case .sffv:
      viewController = FacetSearchDemoViewController()
      
    case .toggle:
      viewController = ToggleDemoViewController()
      
    case .toggleDefault:
      viewController = ToggleDefaultDemoViewController()
      
    case .facetList:
      viewController = RefinementListDemoViewController()
      
    case .facetListPersistentSelection:
      viewController = RefinementPersistentListDemoViewController()
      
    case .segmented:
      viewController = SegmentedDemoViewController()

    case .filterNumericComparison:
      viewController = FilterNumericComparisonDemoViewController()

    case .filterNumericRange:
      viewController = FilterNumericRangeDemoViewController()

    case .sortBy:
      viewController = IndexSegmentDemoViewController()

    case .currentFilters:
      viewController = CurrentFiltersDemoViewController()
      
    case .clearFilters:
      viewController = ClearFiltersDemoViewController()
      
    case .multiIndex:
      viewController = MultiIndexDemoViewController()
      
    case .facetFilterList:
      viewController = FilterListDemo.facet()
            
    case .numericFilterList:
      viewController = FilterListDemo.numeric()
      
    case .tagFilterList:
      viewController = FilterListDemo.tag()
      
    case .searchOnSubmit:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchOnSubmit)
      
    case .searchAsYouType:
      viewController = SearchInputDemoViewController(searchTriggeringMode: .searchAsYouType)
      
    case .stats:
      viewController = StatsDemoViewController()
      
    case .highlighting:
      viewController = HighlightingDemoViewController()
      
    case .loading:
      viewController = LoadingDemoViewController()

    case .hierarchical:
      viewController = HierarchicalDemoViewController()
    }
    
    return viewController
  }
  
}

extension DemoListViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    searcher.query = searchController.searchBar.text
    searcher.search()
  }
}

extension DemoListViewController: UITableViewDataSource {
  
  func updateDemos(_ demos: [Demo]) {
    let demosPerType = Dictionary(grouping: demos, by: { $0.type })
    self.groupedDemos = demosPerType
      .sorted { $0.key < $1.key }
      .map { ($0.key, $0.value.sorted { $0.name < $1.name } ) }
    tableView.reloadData()
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
    
    guard let demoID = Demo.ID(rawValue: demo.objectID) else {
      let notImplementedAlertController = UIAlertController(title: nil, message: "This demo is not implemented yet", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .cancel, handler: .none)
      notImplementedAlertController.addAction(okAction)
      navigationController?.present(notImplementedAlertController, animated: true, completion: .none)
      return
    }
    
    let viewController = self.viewController(for: demoID)
    viewController.title = demo.name
    
    navigationController?.pushViewController(viewController, animated: true)
  }
  
}
