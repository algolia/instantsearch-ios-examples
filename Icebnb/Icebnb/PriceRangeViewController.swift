//
//  PriceRangeViewController.swift
//  Icebnb
//
//  Created by Robert Mogos on 07/09/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import InstantSearchCore
import InstantSearch
import WARangeSlider
import KUIPopOver

class PriceRangeViewController: UIViewController {
  
  @IBOutlet weak var maxLabel: UILabel!
  @IBOutlet weak var minLabel: UILabel!
  @IBOutlet weak var slider: RangeSlider!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    InstantSearch.shared.registerAllWidgets(in: self.view)
    InstantSearch.shared.register(widget: slider)
    slider.addTarget(self, action: #selector(rangeSliderValueChanged), for: .valueChanged)
    rangeSliderValueChanged()
  }
  
  @objc public func rangeSliderValueChanged() {
    minLabel.text = "\(Int(slider.lowerValue))$"
    maxLabel.text = "\(Int(slider.upperValue))$"
  }
}

extension PriceRangeViewController: KUIPopOverUsable {
  var contentSize: CGSize {
      let size = CGSize(width: PopoverConstants.popoverWidth,
                        height: PopoverConstants.popoverRangeHeight)
      return size
  }
  
  var contentView: UIView {
    get {
      return self.view
    }
  }
  
  var arrowDirection: UIPopoverArrowDirection {
    get {
      return .up
    }
  }
}

