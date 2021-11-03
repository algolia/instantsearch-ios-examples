//
//  MultiIndexSearchExample.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

struct Movie: Codable {
  let title: String
}

struct Actor: Codable {
  let name: String
}

enum MultiIndexSearchExample {
  
  class SearchViewController: UIViewController {
    
    let searchController: UISearchController
    let queryInputConnector: QueryInputConnector
    let textFieldController: TextFieldController

    let searcher: MultiSearcher
    let actorHitsInteractor: HitsInteractor<Actor>
    let movieHitsInteractor: HitsInteractor<Movie>
    
    let hitsViewController: HitsViewController
      
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      searcher = .init(appID: "latency",
                       apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
      hitsViewController = .init(style: .plain)
      actorHitsInteractor = .init(infiniteScrolling: .off)
      movieHitsInteractor = .init(infiniteScrolling: .off)
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
      
      let actorsSearcher = searcher.addHitsSearcher(indexName: "mobile_demo_actors")
      actorHitsInteractor.connectSearcher(actorsSearcher)
      hitsViewController.actorsHitsInteractor = actorHitsInteractor
      
      let moviesSearcher = searcher.addHitsSearcher(indexName: "mobile_demo_movies")
      movieHitsInteractor.connectSearcher(moviesSearcher)
      hitsViewController.moviesHitsInteractor = movieHitsInteractor
      
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
      case actors
      case movies
      
      var title: String {
        switch self {
        case .actors:
          return "Actors"
        case .movies:
          return "Movies"
        }
      }
          
      init?(section: Int) {
        self.init(rawValue: section)
      }
      
      init?(indexPath: IndexPath) {
        self.init(section: indexPath.section)
      }
      
    }
        
    weak var actorsHitsInteractor: HitsInteractor<Actor>? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = actorsHitsInteractor else { return }
        interactor.onResultsUpdated.subscribe(with: tableView) { tableView, _ in
          tableView.reloadData()
        }.onQueue(.main)
      }
    }
    
    weak var moviesHitsInteractor: HitsInteractor<Movie>? {
      didSet {
        oldValue?.onResultsUpdated.cancelSubscription(for: tableView)
        guard let interactor = moviesHitsInteractor else { return }
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
      case .actors:
        return actorsHitsInteractor?.numberOfHits() ?? 0
      case .movies:
        return moviesHitsInteractor?.numberOfHits() ?? 0
      }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
      
      guard let section = Section(indexPath: indexPath) else { return cell }
      
      let labelText: String?
      
      switch section {
      case .actors:
        labelText = actorsHitsInteractor?.hit(atIndex: indexPath.row)?.name
      case .movies:
        labelText = moviesHitsInteractor?.hit(atIndex: indexPath.row)?.title
      }
      
      cell.textLabel?.text = labelText

      return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return Section(section: section)?.title
    }
    
  }
  
}
