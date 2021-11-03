//
//  ViewController.swift
//  DemoAutocomplete
//
//  Created by Vladislav Fitc on 30/10/2021.
//

import UIKit
import InstantSearch
import SwiftUI

// QS
// QS with hits
// QS with categories
// QS with recent searches
// QS with recent searches and categories

enum Demo: Int, CaseIterable {
  case querySuggestions
  case facetsAndHits
  case multiHits
  case querySuggestionsAndRecentSearches
  
  var title: String {
    switch self {
    case .facetsAndHits:
      return "Facets and hits search"
    case .multiHits:
      return "Multi-index search"
    case .querySuggestions:
      return "Query suggestions"
    case .querySuggestionsAndRecentSearches:
      return "Query suggestions and recent searches"
    }
  }
}

class ViewController: UITableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Demo.allCases.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "demoCell", for: indexPath)
    if let demo = Demo(rawValue: indexPath.row) {
      cell.textLabel?.text = demo.title
    }
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let demo = Demo(rawValue: indexPath.row) else {
      return
    }
    let viewController: UIViewController
    switch demo {
    case .querySuggestions:
      viewController = QuerySuggestions.SearchViewController()
    case .multiHits:
      viewController = MultiIndexSearchExample.SearchViewController()
    case .facetsAndHits:
      viewController = HitsAndFacetsSearchExample.SearchViewController()
    case .querySuggestionsAndRecentSearches:
      viewController = QuerySuggestionsAndRecentSearches.SearchViewController()
    }
    navigationController?.pushViewController(viewController, animated: true)
  }

}

