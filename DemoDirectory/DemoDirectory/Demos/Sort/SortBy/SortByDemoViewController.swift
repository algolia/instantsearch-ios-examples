//
//  SortByDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 06/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import UIKit
import InstantSearch

class SortByDemoViewController: UIViewController {
  
  typealias HitType = Movie
  
  let controller: SortByDemoController

  let searchController: UISearchController
  let textFieldController: TextFieldController
  let hitsTableViewController: MovieHitsTableViewController<HitType>

  let selectIndexViewController: SelectIndexViewController
  
  private let cellIdentifier = "CellID"

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.hitsTableViewController = .init()
    self.searchController = .init(searchResultsController: hitsTableViewController)
    self.textFieldController = TextFieldController(searchBar: searchController.searchBar)
    self.selectIndexViewController = .init()
    self.controller = .init()
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

  private func setup() {
    controller.hitsConnector.connectController(hitsTableViewController)
    controller.queryInputConnector.connectController(textFieldController)
    controller.switchIndexConnector.connectController(selectIndexViewController)
    controller.switchIndexConnector.interactor.onSelectionChange.subscribe(with: self) { viewController, selectedIndexName in
      viewController.setChangeIndexButton(with: selectedIndexName)
    }
  }

}

extension SortByDemoViewController {
      
  func setChangeIndexButton(with index: IndexName) {
    let title = "Sort by: \(selectIndexViewController.title(for: index))"
    navigationItem.rightBarButtonItem = .init(title: title, style: .done, target: self, action: #selector(self.editButtonTapped(sender:)))
  }

  fileprivate func setupUI() {
    title = "Movies"
    view.backgroundColor = .white
    definesPresentationContext = true
    navigationItem.searchController = searchController
    setChangeIndexButton(with: controller.indexTitle)
    hitsTableViewController.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.showsSearchResultsController = true
    searchController.automaticallyShowsCancelButton = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchController.isActive = true
  }

  @objc func editButtonTapped(sender: UIBarButtonItem) {
    selectIndexViewController.alertController.popoverPresentationController?.barButtonItem = sender
    present(selectIndexViewController.alertController, animated: true, completion: nil)
  }

}

class SelectIndexViewController: SwitchIndexController {
  
  var alertController: UIAlertController
  
  public var select: (IndexName) -> Void = { _ in }
    
  init() {
    let alertController = UIAlertController(title: "Change Index",
                                            message: "Please select a new index",
                                            preferredStyle: .actionSheet)
    alertController.addAction(.init(title: "Cancel",
                                    style: .cancel, handler:
                                      nil))
    self.alertController = alertController
  }
  
  func title(for indexName: IndexName) -> String {
    switch indexName {
    case "mobile_demo_movies":
      return "Default"
    case "mobile_demo_movies_year_asc":
      return "Year Asc"
    case "mobile_demo_movies_year_desc":
      return "Year Desc"
    default:
      return indexName.rawValue
    }
  }
  
  func set(indexNames: [IndexName], selected: IndexName) {
    let alertController = UIAlertController(title: "Change Index",
                                            message: "Please select a new index",
                                            preferredStyle: .actionSheet)
    indexNames.map { indexName in
      UIAlertAction(title: title(for: indexName), style: .default) { [weak self] _ in
        self?.select(indexName)
      }
    }.forEach(alertController.addAction)
    alertController.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
    self.alertController = alertController
  }
  
}
