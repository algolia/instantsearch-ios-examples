//
//  HitsAndFacetsSearchExample.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 10/09/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

enum HitsAndFacetsSearchExample {
  
  class SearchViewController: UIViewController {
    
    let searchController: UISearchController
    let queryInputConnector: QueryInputConnector
    let textFieldController: TextFieldController

    let searcher: CompositeSearcher
    let brandFacetsInteractor: FacetListInteractor
    let productsHitsInteractor: HitsInteractor<ShopItem>
    
    let hitsViewController: HitsViewController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      searcher = .init(appID: "latency",
                       apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
      hitsViewController = .init(style: .plain)
      brandFacetsInteractor = .init()
      productsHitsInteractor = .init()
      searchController = .init(searchResultsController: hitsViewController)
      textFieldController = .init(searchBar: searchController.searchBar)
      queryInputConnector = .init(searcher: searcher,
                                  controller: textFieldController)
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      configureUI()
      
      let facetsSearcher = searcher.addFacetsSearcher(indexName: "instant_search",
                                                      attribute: "brand")
      brandFacetsInteractor.connectFacetSearcher(facetsSearcher)
      hitsViewController.brandFacetsInteractor = brandFacetsInteractor

      let hitsSearcher = searcher.addHitsSearcher(indexName: "instant_search")
      productsHitsInteractor.connectSearcher(hitsSearcher)
      hitsViewController.productsHitsInteractor = productsHitsInteractor
      
      searcher.search()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      searchController.isActive = true
    }
    
    func configureUI() {
      view.backgroundColor = .white
      definesPresentationContext = true
      searchController.hidesNavigationBarDuringPresentation = false
      searchController.showsSearchResultsController = true
      searchController.automaticallyShowsCancelButton = false
      navigationItem.searchController = searchController
    }
    
  }

  class HitsViewController: UITableViewController {
    
    enum Section: Int, CaseIterable {
      case brands
      case products
      
      var title: String {
        switch self {
        case .brands:
          return "Brands"
        case .products:
          return "Products"
        }
      }
            
      init?(section: Int) {
        self.init(rawValue: section)
      }
      
      init?(indexPath: IndexPath) {
        self.init(rawValue: indexPath.section)
      }
      
      
    }

    weak var brandFacetsInteractor: FacetListInteractor? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = brandFacetsInteractor else { return }
        interactor.onResultsUpdated.subscribe(with: tableView) { tableView, _ in
          tableView.reloadData()
        }.onQueue(.main)
      }
    }
    
    weak var productsHitsInteractor: HitsInteractor<ShopItem>? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = productsHitsInteractor else { return }
        interactor.onResultsUpdated.subscribe(with: tableView) { tableView, _ in
          tableView.reloadData()
        }.onQueue(.main)
      }
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let section = Section(section: section) else { return 0 }
      switch section {
      case .brands:
        return brandFacetsInteractor?.items.count ?? 0
      case .products:
        return productsHitsInteractor?.numberOfHits() ?? 0
      }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)

      guard let section = Section(indexPath: indexPath) else { return cell }
      
      let labelText: String?

      switch section {
      case .brands:
        labelText = brandFacetsInteractor?.items[indexPath.row].value
        
      case .products:
        labelText = productsHitsInteractor?.hit(atIndex: indexPath.row)?.name
      }
      
      cell.textLabel?.text = labelText

      return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return Section(section: section)?.title
    }
    
  }

}
