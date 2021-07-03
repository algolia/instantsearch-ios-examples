//
//  HierarchicalDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class HierarchicalDemoController {
  
  let searcher: SingleIndexSearcher
  let filterState: FilterState
  let hierarchicalConnector: HierarchicalConnector
  
  struct HierarchicalCategory {
    static var base: Attribute = "hierarchicalCategories"
    static var lvl0: Attribute { return Attribute(rawValue: base.description + ".lvl0")  }
    static var lvl1: Attribute { return Attribute(rawValue: base.description + ".lvl1") }
    static var lvl2: Attribute { return Attribute(rawValue: base.description + ".lvl2") }
  }
  
  let order = [
    HierarchicalCategory.lvl0,
    HierarchicalCategory.lvl1,
    HierarchicalCategory.lvl2,
  ]
  
  init<Controller: HierarchicalController>(controller: Controller) where Controller.Item == [HierarchicalFacet] {
    searcher = SingleIndexSearcher(client: .demo, indexName: "mobile_demo_hierarchical")
    filterState = .init()
    hierarchicalConnector = .init(searcher: searcher,
                                  filterState: filterState,
                                  hierarchicalAttributes: order,
                                  separator: " > ",
                                  controller: controller,
                                  presenter: DefaultPresenter.Hierarchical.present)
    searcher.connectFilterState(filterState)
    searcher.search()
  }
  
}
