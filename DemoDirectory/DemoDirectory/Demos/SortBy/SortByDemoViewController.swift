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

  let searchBar: UISearchBar
  
  let textFieldController: TextFieldController
  let hitsTableViewController: MovieHitsTableViewController<HitType>

  let selectIndexAlertController: SelectIndexController = {
    let alert = UIAlertController(title: "Change Index",
                                  message: "Please select a new index",
                                  preferredStyle: .actionSheet)
    return .init(alertController: alert)
  }()

  private let cellIdentifier = "CellID"

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searchBar = UISearchBar()
    self.textFieldController = TextFieldController(searchBar: searchBar)
    self.hitsTableViewController = .init()
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
    controller.sortByConnector.connectController(selectIndexAlertController, presenter: { self.title(for: $0.name) } )
    controller.sortByConnector.interactor.onSelectedComputed.subscribe(with: self) { (viewController, index) in
      index.flatMap { viewController.controller.indexes[$0] }.flatMap(viewController.setChangeIndexButton)
    }
  }

}

extension SortByDemoViewController {
  
  func index(for name: IndexName) -> Index {
    SearchClient.demo.index(withName: name)
  }
  
  func title(for indexName: IndexName) -> String {
    switch indexName {
    case controller.indexTitle:
      return "Default"
    case controller.indexYearAsc:
      return "Year Asc"
    case controller.indexYearDesc:
      return "Year Desc"
    default:
      return indexName.rawValue
    }
  }
  
  func setChangeIndexButton(with index: IndexName) {
    let title = "Sort by: \(self.title(for: index))"
    navigationItem.rightBarButtonItem = .init(title: title, style: .done, target: self, action: #selector(self.editButtonTapped(sender:)))
  }

  fileprivate func setupUI() {

    title = "Movies"
    view.backgroundColor = .white

    setChangeIndexButton(with: controller.indexTitle)

    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true

    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
  
    let tableView = hitsTableViewController.tableView!
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = .px16
    
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(tableView)
    
    view.addSubview(stackView)

    stackView.pin(to: view.safeAreaLayoutGuide)

  }

  @objc func editButtonTapped(sender: UIBarButtonItem) {
    selectIndexAlertController.alertController.popoverPresentationController?.barButtonItem = sender
    present(selectIndexAlertController.alertController, animated: true, completion: nil)
  }

}

