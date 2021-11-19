//
//  VoiceInputDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch
import InstantSearchVoiceOverlay

class VoiceInputDemoViewController: UIViewController, UISearchBarDelegate {
  
  let searcher: HitsSearcher
  let searchConnector: SearchConnector<Item>
  
  let searchController: UISearchController
  let searchResultsController: SearchResultsViewController
  let voiceOverlayController: VoiceOverlayController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searcher = .init(appID: "latency",
                     apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                     indexName: "instant_search")
    searchResultsController = .init()
    voiceOverlayController = .init()
    searchController = .init(searchResultsController: searchResultsController)
    searchConnector = .init(searcher: searcher,
                            searchController: searchController,
                            hitsInteractor: .init(),
                            hitsController: searchResultsController)
    searchConnector.connect()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    searcher.search()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }
  
  func configureUI() {
    title = "Voice Search"
    view.backgroundColor = .white
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
    navigationItem.searchController = searchController
    searchController.searchBar.setImage(UIImage(systemName: "mic.fill"), for: .bookmark, state: .normal)
    searchController.searchBar.showsBookmarkButton = true
    searchController.searchBar.delegate = self
  }
  
  func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
    voiceOverlayController.start(on: self.navigationController!) { [weak self] (text, isFinal, _) in
      self?.searchConnector.queryInputConnector.interactor.query = text
    } errorHandler: { error in
      guard let error = error else { return }
      DispatchQueue.main.async { [weak self] in
        self?.present(error)
      }
    }
  }
  
  func present(_ error: Error) {
    let alertController = UIAlertController(title: "Error",
                                            message: error.localizedDescription,
                                            preferredStyle: .alert)
    alertController.addAction(.init(title: "OK",
                                    style: .cancel,
                                    handler: .none))
    navigationController?.present(alertController,
                                  animated: true,
                                  completion: nil)
  }

  
  class SearchResultsViewController: UITableViewController, HitsController {
    
    var hitsSource: HitsInteractor<Item>?
      
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      hitsSource?.numberOfHits() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = hitsSource?.hit(atIndex: indexPath.row)?.name
      return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let _ = hitsSource?.hit(atIndex: indexPath.row) {
        // Handle hit selection
      }
    }
    
  }
  
}
