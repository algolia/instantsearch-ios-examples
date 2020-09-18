//
//  MultiIndexSearchConnectorSearchViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 23/07/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class MultiIndexSearchConnectorSearchViewController: UIViewController {
  
  let widget: MultiIndexSearchConnector
  
  let searchBar: UISearchBar
  let textFieldController: TextFieldController
  let hitsViewController: MultiIndexWidgetHitsViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    // Instantiate ViewControllers
    searchBar = UISearchBar()
    hitsViewController = MultiIndexWidgetHitsViewController()
    textFieldController = TextFieldController(searchBar: searchBar)
    
    // Instantiate widget
    widget = MultiIndexSearchConnector(appID: "latency",
                                    apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                    indexModules: [
                                      .init(indexName: "mobile_demo_actors", hitType: Actor.self),
                                      .init(indexName: "mobile_demo_movies", hitType: Movie.self)
      ],
                                    hitsController: hitsViewController,
                                    queryInputController: textFieldController)
    widget.connect()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  func configureUI() {
    view.backgroundColor = .white
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 16
    stackView.axis = .vertical
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    stackView.isLayoutMarginsRelativeArrangement = true
    
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    searchBar.searchBarStyle = .minimal
    
    stackView.addArrangedSubview(searchBar)
    
    hitsViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(hitsViewController.tableView)
    
    view.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])

  }

}
