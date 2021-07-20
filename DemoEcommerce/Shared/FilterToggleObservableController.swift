//
//  FilterToggleObservableController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 11/04/2021.
//

import Foundation
import InstantSearch

public class FilterToggleObservableController<Filter: FilterType>: ObservableObject, SelectableController {
    
  @Published public var isSelected: Bool = false {
    didSet {
      if oldValue != isSelected {
        onClick?(isSelected)
      }
    }
  }
  
  public var onClick: ((Bool) -> Void)?
  
  public func setSelected(_ isSelected: Bool) {
    self.isSelected = isSelected
  }
    
  public func setItem(_ item: Filter) {
  }
  
}
