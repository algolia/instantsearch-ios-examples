//
//  HierarchicalObservableController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 21/04/2021.
//

import Foundation
import InstantSearch

public class HierarchicalObservableController: ObservableObject, HierarchicalController {
      
  @Published public var items: [HierarchicalFacet] = []
  
  public var onClick: ((String) -> Void)?
  
  public func setItem(_ facets: [HierarchicalFacet]) {
    self.items = facets
  }
  
  public func select(_ facetValue: String) {
    onClick?(facetValue)
  }
    
}
