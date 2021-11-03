//
//  QuerySuggestionsAndRecentSearches.swift
//  DemoAutocomplete
//
//  Created by Vladislav Fitc on 03/11/2021.
//

import Foundation
import InstantSearch
import UIKit

enum QuerySuggestionsAndRecentSearches {
  
  class SearchViewController: UIViewController {
    
    let searchController: UISearchController
    
    let queryInputConnector: QueryInputConnector
    let textFieldController: TextFieldController

    let hitsSearcher: HitsSearcher
    let hitsInteractor: HitsInteractor<QuerySuggestion>
    
    let searchResultsController: SearchResultsController
        
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      hitsSearcher = .init(appID: "latency",
                           apiKey: "afc3dd66dd1293e2e2736a5a51b05c0a",
                           indexName: "instantsearch_query_suggestions")
      searchResultsController = .init()
      hitsInteractor = .init()
      searchController = .init(searchResultsController: searchResultsController)
      textFieldController = .init(searchBar: searchController.searchBar)
      queryInputConnector = .init(searcher: hitsSearcher,
                                  controller: textFieldController)
      hitsInteractor.connectSearcher(hitsSearcher)
      hitsInteractor.connectController(searchResultsController)
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      searchResultsController.onTypeAhead = { [weak self] in
        self?.queryInputConnector.interactor.query = $0
      }
      searchResultsController.onSelection = { [weak self] in
        self?.queryInputConnector.interactor.query = $0
      }
      searchController.searchBar.searchTextField.addTarget(self, action: #selector(textFieldSubmitted), for: .editingDidEndOnExit)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
      hitsSearcher.search()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      searchController.isActive = true
    }
    
    func configureUI() {
      view.backgroundColor = .white
      searchController.hidesNavigationBarDuringPresentation = false
      searchController.showsSearchResultsController = true
      searchController.automaticallyShowsCancelButton = false
      navigationItem.searchController = searchController
    }
    
    @objc func textFieldSubmitted() {
      guard let text = searchController.searchBar.text else { return }
      if let alreadyPresentIndex = searchResultsController.recentSearches.firstIndex(where: { $0 == text }) {
        searchResultsController.recentSearches.remove(at: alreadyPresentIndex)
      }
      searchResultsController.recentSearches.insert(text, at: searchResultsController.recentSearches.startIndex)
      searchResultsController.tableView.reloadData()
    }
    
  }

  class SearchResultsController: UITableViewController, HitsController {
        
    var hitsSource: HitsInteractor<QuerySuggestion>?
    
    var recentSearches: [String] = []
    
    var onTypeAhead: ((String) -> Void)?
    var onSelection: ((String) -> Void)?
    
    enum Section: Int, CaseIterable {
      case recentSearches
      case querySuggestions
      
      var header: String {
        switch self {
        case .querySuggestions:
          return "Suggestions"
        case .recentSearches:
          return "Recent searches"
        }
      }
    }
    
    private func suggestionTypeAheadButton() -> UIButton {
      let typeAheadButton = UIButton()
      typeAheadButton.setImage(UIImage(systemName: "arrow.up.left"), for: .normal)
      typeAheadButton.sizeToFit()
      typeAheadButton.addTarget(self, action: #selector(didTapSuggestionTypeAheadButton), for: .touchUpInside)
      return typeAheadButton
    }
    
    private func recentSearchTypeAheadButton() -> UIButton {
      let typeAheadButton = UIButton()
      typeAheadButton.setImage(UIImage(systemName: "arrow.up.left"), for: .normal)
      typeAheadButton.sizeToFit()
      typeAheadButton.addTarget(self, action: #selector(didTapRecentSearchTypeAheadButton), for: .touchUpInside)
      return typeAheadButton
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
      return Section.allCases.count
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let section = Section(rawValue: section) else { return 0 }
      switch section {
      case .recentSearches:
        return recentSearches.count
      case .querySuggestions:
        return hitsSource?.numberOfHits() ?? 0
      }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
      switch section {
      case .recentSearches:
        cell.imageView?.image = UIImage(systemName: "clock.arrow.circlepath")
        cell.textLabel?.text = recentSearches[indexPath.row]
        let typeAheadButton = recentSearchTypeAheadButton()
        typeAheadButton.tag = indexPath.row
        cell.accessoryView = typeAheadButton
        
      case .querySuggestions:
        cell.imageView?.image = nil
        cell.textLabel?.attributedText = hitsSource?
          .hit(atIndex: indexPath.row)?
          .highlighted
          .flatMap(HighlightedString.init)
          .flatMap { NSAttributedString(highlightedString: $0,
                                        inverted: true,
                                        attributes: [.font: UIFont.boldSystemFont(ofSize: cell.textLabel!.font.pointSize)])
        }
        let typeAheadButton = suggestionTypeAheadButton()
        typeAheadButton.tag = indexPath.row
        cell.accessoryView = typeAheadButton
      }
      return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let section = Section(rawValue: indexPath.section) else { return }
      switch section {
      case .recentSearches:
        onSelection?(recentSearches[indexPath.row])
        
      case .querySuggestions:
        hitsSource?.hit(atIndex: indexPath.row).flatMap {
          onSelection?($0.query)
        }
      }
    }
    
    @objc func didTapRecentSearchTypeAheadButton(_ sender: UIButton) {
      onTypeAhead?(recentSearches[sender.tag])
    }
    
    @objc func didTapSuggestionTypeAheadButton(_ sender: UIButton) {
      hitsSource?.hit(atIndex: sender.tag).flatMap {
        onTypeAhead?($0.query)
      }
    }
        
  }

}
