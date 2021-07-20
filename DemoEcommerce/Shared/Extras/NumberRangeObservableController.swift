//
//  PriceController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 21/04/2021.
//

import Foundation
import InstantSearch

public class NumberRangeObservableController<Number: Comparable & DoubleRepresentable>: ObservableObject, NumberRangeController {
      
  @Published public var range: ClosedRange<Number> = Number(0)...Number(1) {
    didSet {
      if oldValue != range {
        onRangeChanged?(range)
      }
    }
  }
  
  @Published public var bounds: ClosedRange<Number> = Number(0)...Number(1)
  
  public var onRangeChanged: ((ClosedRange<Number>) -> Void)?
  
  private var isInitialBoundsSet: Bool = true
  
  public func setItem(_ range: ClosedRange<Number>) {
    self.range = range
  }
  
  public func setBounds(_ bounds: ClosedRange<Number>) {
    self.bounds = bounds
    if isInitialBoundsSet {
      isInitialBoundsSet = false
      self.range = bounds
    }
  }
  
  public init(range: ClosedRange<Number>,
              bounds: ClosedRange<Number>) {
    self.range = range.clamped(to: bounds)
    self.bounds = bounds
  }
  
}
