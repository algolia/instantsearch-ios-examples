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

  let searcher: SingleIndexSearcher
  let queryInputInteractor: QueryInputInteractor
  let hitsInteractor: HitsInteractor<HitType>
  let indexSegmentInteractor: IndexSegmentInteractor
  
  
  let indexTitle: IndexName = "mobile_demo_movies"
  let indexYearAsc: IndexName = "mobile_demo_movies_year_asc"
  let indexYearDesc: IndexName = "mobile_demo_movies_year_desc"

  let indexes: [Int: IndexName]
  
  init() {
    self.searcher = SingleIndexSearcher(client: .demo, indexName: "mobile_demo_movies")
    self.hitsInteractor = .init()
    self.queryInputInteractor = .init()
    indexes = [
      0 : indexTitle,
      1 : indexYearAsc,
      2 : indexYearDesc
    ]
    indexSegmentInteractor = IndexSegmentInteractor(items: indexes.mapValues(SearchClient.demo.index(withName:)))
    
    searcher.search()
    searcher.isDisjunctiveFacetingEnabled = false
    
    hitsInteractor.connectSearcher(searcher)
    queryInputInteractor.connectSearcher(searcher)
    indexSegmentInteractor.connectSearcher(searcher: searcher)

  }
  
}
