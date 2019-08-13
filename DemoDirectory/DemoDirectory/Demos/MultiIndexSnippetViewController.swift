//
//  MultiIndexSnippet.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 25/07/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class MultiIndexSnippetViewController: UIViewController {
  
  let tableView: UITableView
  
  let searcher: MultiIndexSearcher
  let hitsInteractor: MultiIndexHitsInteractor
  let tableController: MultiIndexHitsTableController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    
    tableView = .init()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")

    searcher = .init(appID: "latency",
                     apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                     indexNames: ["mobile_demo_actors", "mobile_demo_movies"])
    
    let actorHitsInteractor: HitsInteractor<Actor> = .init(infiniteScrolling: .off)
    let movieHitsInteractor: HitsInteractor<Movie> = .init(infiniteScrolling: .off)
    
    hitsInteractor = .init(hitsInteractors: [actorHitsInteractor, movieHitsInteractor])
    tableController = .init(tableView: tableView)
    
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(tableController)
    
    searcher.search()
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    configureTableController()
  }
  
  func configureTableController() {
    
    let dataSource = MultiIndexHitsTableViewDataSource()
    
    dataSource.setCellConfigurator(forSection: 0) { (tableView, actor: Actor, indexPath) in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
      cell.textLabel?.text = actor.name
      return cell
    }
    
    dataSource.setCellConfigurator(forSection: 1) { (tableView, movie: Movie, indexPath) in
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
      cell.textLabel?.text = movie.title
      return cell
    }
    
    tableController.dataSource = dataSource
    
    let delegate = MultiIndexHitsTableViewDelegate()
    
    delegate.setClickHandler(forSection: 0) { (tableView, actor: Actor, indexPath) in
      // Actor selection action
    }
    
    delegate.setClickHandler(forSection: 1) { (tableView, movie: Movie, indexPath) in
      // Movie selection action
    }
    
    tableController.delegate = delegate

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    tableView.pin(to: view.safeAreaLayoutGuide)
  }
  
}
