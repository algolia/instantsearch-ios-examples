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
  let sortByConnector: SortByConnector
  
  let indexTitle: IndexName = "mobile_demo_movies"
  let indexYearAsc: IndexName = "mobile_demo_movies_year_asc"
  let indexYearDesc: IndexName = "mobile_demo_movies_year_desc"

  let indexes: [Int: IndexName]
  
  init() {
    self.searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_movies")
    self.queryInputConnector = .init(searcher: searcher)
    self.hitsConnector = .init(searcher: searcher)
    indexes = [
      0 : indexTitle,
      1 : indexYearAsc,
      2 : indexYearDesc
    ]
    sortByConnector = .init(searcher: searcher, indicesNames: [indexTitle, indexYearAsc, indexYearDesc], selected: 0)
    
    searcher.search()
    searcher.isDisjunctiveFacetingEnabled = false
  }
  
}
