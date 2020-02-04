//
//  SearchSuggestionsDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 13/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

struct ShopItem: Codable {
  let name: String
  let description: String
  let brand: String
  let image: URL
}

class ShopItemTableViewCell: UITableViewCell {
  
  let itemImageView: UIImageView
  let titleLabel: UILabel
  let subtitleLabel: UILabel
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    itemImageView = .init(frame: .zero)
    titleLabel = .init(frame: .zero)
    subtitleLabel = .init(frame: .zero)
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func layout() {
    
    itemImageView.translatesAutoresizingMaskIntoConstraints = false
    itemImageView.clipsToBounds = true
    itemImageView.contentMode = .scaleAspectFit
    itemImageView.layer.masksToBounds = true
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
    titleLabel.numberOfLines = 0
    
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    subtitleLabel.font = .systemFont(ofSize: 10, weight: .regular)
    subtitleLabel.textColor = .gray
    subtitleLabel.numberOfLines = 0
        
    let mainStackView = UIStackView()
    mainStackView.axis = .horizontal
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.spacing = 5
    
    let labelsStackView = UIStackView()
    labelsStackView.axis = .vertical
    labelsStackView.translatesAutoresizingMaskIntoConstraints = false
    labelsStackView.spacing = 3
    
    labelsStackView.addArrangedSubview(titleLabel)
    labelsStackView.addArrangedSubview(subtitleLabel)
    labelsStackView.addArrangedSubview(UIView())
    
    let itemImageContainer = UIView()
    itemImageContainer.translatesAutoresizingMaskIntoConstraints = false
    itemImageContainer.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
    itemImageContainer.addSubview(itemImageView)
    itemImageView.pin(to: itemImageContainer.layoutMarginsGuide)
    
    mainStackView.addArrangedSubview(itemImageContainer)
    mainStackView.addArrangedSubview(labelsStackView)
    
    contentView.addSubview(mainStackView)
    
    itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor).isActive = true
    
    mainStackView.pin(to: contentView)
  }
  
}

class ResultsViewController: UITableViewController, HitsController {
    
  var hitsSource: HitsInteractor<ShopItem>?
  
  let cellID = "cellID"
  
  override init(style: UITableView.Style) {
    super.init(style: style)
    tableView.register(ShopItemTableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func reload() {
    tableView.reloadData()
  }
  
  func scrollToTop() {
    tableView.scrollToFirstNonEmptySection()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? ShopItemTableViewCell,
      let item = hitsSource?.hit(atIndex: indexPath.row) else {
        return .init()
    }
    cell.itemImageView.sd_setImage(with: item.image)
    cell.titleLabel.text = item.name
    cell.subtitleLabel.text = item.brand
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
}

class SearchSuggestionsDemoViewController: UIViewController {
  
  let searchController: UISearchController
  
  let multiIndexHitsConnector: MultiIndexHitsConnector
  
  let queryInputInteractor: QueryInputInteractor
  let searchBarController: SearchBarController
    
  let suggestionsViewController: QuerySuggestionsViewController
  let resultsViewController: ResultsViewController
  
  let appID = "latency"
  let apiKey = "afc3dd66dd1293e2e2736a5a51b05c0a"
  let suggestionsIndex = "instantsearch_query_suggestions"
  let resultsIndex = "instant_search"
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    
    suggestionsViewController = .init(style: .plain)
    suggestionsViewController.isHighlightingInverted = true
    resultsViewController = .init(style: .plain)
    
    searchController = .init(searchResultsController: suggestionsViewController)
    
    queryInputInteractor = .init()
    searchBarController = .init(searchBar: searchController.searchBar)
    let suggestionsHitsInteractor = HitsInteractor<Hit<QuerySuggestion>>(infiniteScrolling: .off, showItemsOnEmptyQuery: true)
    let itemsHitsInteractor = HitsInteractor<ShopItem>(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true)
    
    multiIndexHitsConnector = .init(appID: appID, apiKey: apiKey, indexModules: [
        .init(indexName: suggestionsIndex, hitsInteractor: suggestionsHitsInteractor),
        .init(indexName: resultsIndex, hitsInteractor: itemsHitsInteractor)
    ])
        
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    queryInputInteractor.connectController(searchBarController)
    queryInputInteractor.connectSearcher(multiIndexHitsConnector.searcher)
    navigationItem.searchController = searchController
    definesPresentationContext = true
    suggestionsViewController.didSelect = { suggestion in
      self.searchController.searchBar.searchTextField.text = suggestion.object.query
      self.searchBarController.onQueryChanged?(suggestion.object.query)
      self.searchController.dismiss(animated: true, completion: .none)
    }
    searchController.searchBar.searchTextField.delegate = self
    suggestionsHitsInteractor.connectController(suggestionsViewController)
    itemsHitsInteractor.connectController(resultsViewController)
    multiIndexHitsConnector.searcher.search()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationItem.hidesSearchBarWhenScrolling = true
  }
  
  func configureUI() {
    view.backgroundColor = .white
    addChild(resultsViewController)
    resultsViewController.didMove(toParent: self)
    resultsViewController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(resultsViewController.view)
    resultsViewController.view.pin(to: view.safeAreaLayoutGuide)
  }
  
}

extension SearchSuggestionsDemoViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    searchController.dismiss(animated: true, completion: .none)
  }
  
}
