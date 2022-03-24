//
//  SuggestionsTableViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 24/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class SuggestionsTableViewController: UITableViewController, HitsController, QueryInputController {
  
  var onQueryChanged: ((String?) -> Void)?
  var onQuerySubmitted: ((String?) -> Void)?
  
  public var hitsSource: HitsInteractor<QuerySuggestion>?

  let cellID = "suggestionCellID"

  public override init(style: UITableView.Style) {
    super.init(style: style)
    tableView.register(SearchSuggestionTableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setQuery(_ query: String?) {
    // not applicable
  }
  
  public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }

  public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? SearchSuggestionTableViewCell else { return .init() }
    
    if let suggestion = hitsSource?.hit(atIndex: indexPath.row) {
      cell.setup(with: suggestion)
      cell.didTapTypeAheadButton = {
        self.onQueryChanged?(suggestion.query)
      }
    }
    
    return cell
  }

  public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let suggestion = hitsSource?.hit(atIndex: indexPath.row) else { return }
    onQuerySubmitted?(suggestion.query)
  }

}

