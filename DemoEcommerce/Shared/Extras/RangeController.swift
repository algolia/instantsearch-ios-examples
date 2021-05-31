//
//  PriceController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 21/04/2021.
//

import Foundation
import InstantSearch

public class RangeController: ObservableObject, NumberRangeController {
    
  @Published public var range: ClosedRange<Int> = 0...1 {
    didSet {
      if oldValue != range {
        onRangeChanged?(range)
      }
    }
  }
  
  @Published public var bounds: ClosedRange<Int> = 0...1
  
  public var onRangeChanged: ((ClosedRange<Int>) -> Void)?
  
  private var isInitialBoundsSet: Bool = true
  
  public func setItem(_ item: ClosedRange<Int>) {
  }
  
  public func invalidate() {
  }
  
  public func setBounds(_ bounds: ClosedRange<Int>) {
    self.bounds = bounds
    if isInitialBoundsSet {
      isInitialBoundsSet = false
      self.range = bounds
    }
  }
  
  public init(range: ClosedRange<Int>, bounds: ClosedRange<Int>) {
    self.range = range
    self.bounds = bounds
  }
  
}
