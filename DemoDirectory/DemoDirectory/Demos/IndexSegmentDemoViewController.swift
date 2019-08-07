//
//  IndexSegmentDemo.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 06/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import UIKit
import InstantSearch

class IndexSegmentDemoViewController: UIViewController {
  
  typealias HitType = Movie

  let searcher: SingleIndexSearcher
  let queryInputInteractor: QueryInputInteractor
  let searchBarController: SearchBarController
  let hitsInteractor: HitsInteractor<HitType>
  let hitsTableViewController: HitsTableViewController<HitType>
  let indexSegmentInteractor: IndexSegmentInteractor

  let indexTitle: Index = .demo(withName: "mobile_demo_movies")
  let indexYearAsc: Index = .demo(withName: "mobile_demo_movies_year_asc")
  let indexYearDesc: Index = .demo(withName: "mobile_demo_movies_year_desc")

  let indexes: [Int: Index]

  let selectIndexAlertController: SelectIndexController = {
    let alert = UIAlertController(title: "Change Index",
                                  message: "Please select a new index",
                                  preferredStyle: .actionSheet)
    return .init(alertController: alert)
  }()

  private let cellIdentifier = "CellID"

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = SingleIndexSearcher(index: .demo(withName: "mobile_demo_movies"))
    self.searchBarController = SearchBarController(searchBar: .init())
    self.hitsInteractor = .init()
    self.hitsTableViewController = .init()
    self.queryInputInteractor = .init()
    indexes = [
      0 : indexTitle,
      1 : indexYearAsc,
      2 : indexYearDesc
    ]
    indexSegmentInteractor = IndexSegmentInteractor(items: indexes)
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
    searcher.search()
    searcher.isDisjunctiveFacetingEnabled = false

    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableViewController)

    queryInputInteractor.connectController(searchBarController)
    queryInputInteractor.connectSearcher(searcher)

    indexSegmentInteractor.connectSearcher(searcher: searcher)

    indexSegmentInteractor.connectController(selectIndexAlertController) { (index) -> String in
      switch index {
      case self.indexTitle: return "Default"
      case self.indexYearAsc: return "Year Asc"
      case self.indexYearDesc: return "Year Desc"
      default: return index.name
      }
    }

  }

}

extension IndexSegmentDemoViewController {

  fileprivate func setupUI() {

    view.backgroundColor = .white

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: #selector(self.editButtonTapped(sender:)))


    let searchBar = searchBarController.searchBar
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
    present(selectIndexAlertController.alertController, animated: true, completion: nil)
  }

}

