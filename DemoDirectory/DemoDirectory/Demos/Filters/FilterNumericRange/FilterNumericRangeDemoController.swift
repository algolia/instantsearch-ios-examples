//
//  FilterNumericRangeDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class FilterNumericRangeDemoController {
  
  let searcher: SingleIndexSearcher
  let filterState: FilterState
  
  let primarySliderConnector: NumberRangeConnector<Double>
  let secondarySliderConnector: NumberRangeConnector<Double>
  
  init(primaryController: NumericRangeController,
       secondaryController: NumericRangeController) {
    self.searcher = SingleIndexSearcher(client: .demo, indexName: "mobile_demo_filter_numeric_comparison")
    self.filterState = .init()
    
    primarySliderConnector = .init(searcher: searcher,
                                   filterState: filterState,
                                   attribute: "price",
                                   controller: primaryController)
    
    secondarySliderConnector = .init(searcher: searcher,
                                     filterState: filterState,
                                     attribute: "price",
                                     controller: secondaryController)
    
    searcher.connectFilterState(filterState)
    searcher.search()
    
  }
  
  
}
