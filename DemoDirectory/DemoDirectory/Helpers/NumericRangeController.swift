//
//  NumericRangeController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit
import WARangeSlider

public class NumericRangeController: NumberRangeController {
  public var onRangeChanged: ((ClosedRange<Double>) -> Void)?

  public typealias Number = Double

  public func setItem(_ item: ClosedRange<Double>) {
    rangerSlider.lowerValue = item.lowerBound
    rangerSlider.upperValue = item.upperBound
  }

  @objc func onValueChanged(sender: RangeSlider) {
    onRangeChanged?(sender.lowerValue.rounded(toPlaces: 2)...sender.upperValue.rounded(toPlaces: 2))
  }

  public func setBounds(_ bounds: ClosedRange<Double>) {
    rangerSlider.minimumValue = bounds.lowerBound
    rangerSlider.maximumValue = bounds.upperBound
    setItem(bounds)
  }

  public let rangerSlider: RangeSlider

  public init(rangeSlider: RangeSlider) {
    self.rangerSlider = rangeSlider
    rangeSlider.addTarget(self, action: #selector(onValueChanged(sender:)), for: [.touchUpInside, .touchUpOutside])
  }

}
