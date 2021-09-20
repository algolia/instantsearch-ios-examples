//
//  SortByDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class SortByDemoController {
  
  typealias HitType = Movie

  let searcher: HitsSearcher
  let queryInputConnector: QueryInputConnector
  let hitsConnector: HitsConnector<HitType>
  let switchIndexConnector: SwitchIndexConnector
  
  let indexTitle: IndexName = "mobile_demo_movies"
  let indexYearAsc: IndexName = "mobile_demo_movies_year_asc"
  let indexYearDesc: IndexName = "mobile_demo_movies_year_desc"
  
  let indices: [IndexName] = [
    "mobile_demo_movies",
    "mobile_demo_movies_year_asc",
    "mobile_demo_movies_year_desc"
  ]
  
  init() {
    self.searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_movies")
    self.queryInputConnector = .init(searcher: searcher)
    self.hitsConnector = .init(searcher: searcher)
    switchIndexConnector = .init(searcher: searcher,
                                 indexNames: indices,
                                 selectedIndexName: indexTitle)
    
    searcher.search()
    searcher.isDisjunctiveFacetingEnabled = false
  }
  
  func title(for indexName: IndexName) -> String {
    switch indexName {
    case indexTitle:
      return "Default"
    case indexYearAsc:
      return "Year Asc"
    case indexYearDesc:
      return "Year Desc"
    default:
      return indexName.rawValue
    }
  }
  
}
