//
//  ViewController.swift
//  DemoAutocomplete
//
//  Created by Vladislav Fitc on 30/10/2021.
//

import UIKit

enum Demo: Int, CaseIterable {
  
  case querySuggestions
  case voiceSearch
  case multiIndex
  case querySuggestionsAndCategories
  case querySuggestionsAndRecentSearches
  case querySuggestionsAndHits
  
  var title: String {
    switch self {
    case .querySuggestions:
      return "Query suggestions"
    case .voiceSearch:
      return "Voice search"
    case .multiIndex:
      return "Multi-index search"
    case .querySuggestionsAndCategories:
      return "Query suggestions and categories"
    case .querySuggestionsAndRecentSearches:
      return "Query suggestions and recent searches"
    case .querySuggestionsAndHits:
      return "Query suggestions and hits"
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
    
    case .voiceSearch:
      viewController = VoiceSearch.SearchViewController()
      
    case .multiIndex:
      viewController = MultiIndex.SearchViewController()
      
    case .querySuggestionsAndCategories:
      viewController = QuerySuggestionsAndCategories.SearchViewController()
      
    case .querySuggestionsAndRecentSearches:
      viewController = QuerySuggestionsAndRecentSearches.SearchViewController()
      
    case .querySuggestionsAndHits:
      viewController = QuerySuggestionsAndHits.SearchViewController()
    }
    
    navigationController?.pushViewController(viewController, animated: true)
  }

}

