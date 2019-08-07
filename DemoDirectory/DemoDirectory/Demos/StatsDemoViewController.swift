//
//  StatsDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import InstantSearch

class StatsDemoViewController: UIViewController {
  
  let stackView = UIStackView()
  
  let searcher: SingleIndexSearcher
  
  let queryInputInteractor: QueryInputInteractor
  let searchBarController: SearchBarController
  
  let statsInteractor: StatsInteractor
  let labelStatsController: LabelStatsController
  let attributedLabelStatsController: AttributedLabelStatsController
  
  init() {
    self.searcher = SingleIndexSearcher(index: .demo(withName: "mobile_demo_movies"))
    self.searchBarController = .init(searchBar: .init())
    self.queryInputInteractor = .init()
    self.statsInteractor = .init()
    self.attributedLabelStatsController = AttributedLabelStatsController(label: .init())
    self.labelStatsController = LabelStatsController(label: .init())
    super.init(nibName: .none, bundle: .none)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  private func setup() {
    
    queryInputInteractor.connectController(searchBarController)
    queryInputInteractor.connectSearcher(searcher)
    
    statsInteractor.connectSearcher(searcher)
    statsInteractor.connectController(labelStatsController) { stats -> String? in
      guard let stats = stats else {
        return nil
      }
      return "\(stats.totalHitsCount) hits in \(stats.processingTimeMS) ms"
    }
    
    statsInteractor.connectController(attributedLabelStatsController) { stats -> NSAttributedString? in
      guard let stats = stats else {
        return nil
      }
      let string = NSMutableAttributedString()
      string.append(NSAttributedString(string: "\(stats.totalHitsCount)", attributes: [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 15)!]))
      string.append(NSAttributedString(string: "  hits"))
      return string
    }
    
    searcher.search()
    
  }
  
}

private extension StatsDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    configureSearchBar()
    configureStackView()
    configureLayout()
  }
  
  func configureSearchBar() {
    let searchBar = searchBarController.searchBar
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
  }
  
  func configureStackView() {
    stackView.spacing = .px16
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureLayout() {
    
    searchBarController.searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    stackView.addArrangedSubview(searchBarController.searchBar)
    let statsMSContainer = UIView()
    statsMSContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
    statsMSContainer.translatesAutoresizingMaskIntoConstraints = false
    statsMSContainer.layoutMargins = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
    labelStatsController.label.translatesAutoresizingMaskIntoConstraints = false
    statsMSContainer.addSubview(labelStatsController.label)
    labelStatsController.label.pin(to: statsMSContainer.layoutMarginsGuide)
    stackView.addArrangedSubview(statsMSContainer)
    
    let attributedStatsContainer = UIView()
    attributedStatsContainer.heightAnchor.constraint(equalToConstant: 44).isActive = true
    attributedStatsContainer.translatesAutoresizingMaskIntoConstraints = false
    attributedStatsContainer.layoutMargins = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
    attributedLabelStatsController.label.translatesAutoresizingMaskIntoConstraints = false
    attributedStatsContainer.addSubview(attributedLabelStatsController.label)
    attributedLabelStatsController.label.pin(to: attributedStatsContainer.layoutMarginsGuide)
    
    stackView.addArrangedSubview(attributedStatsContainer)
    stackView.addArrangedSubview(UIView())
    
    view.addSubview(stackView)
    
    stackView.pin(to: view.safeAreaLayoutGuide)
    
  }
  
}
