//
//  SearchResultController.swift
//  QuerySuggestionsRecentSearches
//
//  Created by Vladislav Fitc on 05/11/2021.
//

import Foundation
import InstantSearch
import UIKit

extension QuerySuggestionsAndRecentSearches {
  
  class SearchResultsController: UITableViewController, HitsController {
        
    var hitsSource: HitsInteractor<QuerySuggestion>?
    
    var recentSearches: [String] = ["last search"]
    
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
      
      var cellReuseIdentifier: String {
        switch self {
        case .querySuggestions:
          return "suggestion"
        case .recentSearches:
          return "recentSearch"
        }
      }
      
    }
        
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: Section.querySuggestions.cellReuseIdentifier)
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: Section.recentSearches.cellReuseIdentifier)
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
      let cell: UITableViewCell
      switch section {
      case .recentSearches:
        cell = tableView.dequeueReusableCell(withIdentifier: Section.recentSearches.cellReuseIdentifier, for: indexPath)
        cell.imageView?.image = UIImage(systemName: "clock.arrow.circlepath")
        cell.textLabel?.text = recentSearches[indexPath.row]
        
      case .querySuggestions:
        cell = tableView.dequeueReusableCell(withIdentifier: Section.querySuggestions.cellReuseIdentifier, for: indexPath)
        if
          let suggestionCell = cell as? SearchSuggestionTableViewCell,
          let suggestion = hitsSource?.hit(atIndex: indexPath.row) {
            suggestionCell.setup(with: suggestion)
        }
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      guard let section = Section(rawValue: section) else { return nil }
      switch section {
      case .recentSearches:
        return recentSearches.isEmpty ? nil : section.header
        
      case .querySuggestions:
        let isEmpty = hitsSource.flatMap { $0.numberOfHits() == 0 } ?? true
        return isEmpty ? nil : section.header
      }
    }
        
  }
  
}
