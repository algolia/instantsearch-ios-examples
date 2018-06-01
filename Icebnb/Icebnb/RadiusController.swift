//
//  RadiusController.swift
//  Icebnb
//
//  Created by Robert Mogos on 12/10/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import KUIPopOver
import InstantSearch

class RadiusController: UIViewController {
  @IBOutlet weak var slider: PRGRoundSlider!
  let searcher: Searcher
  
  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, searcher: Searcher) {
    self.searcher = searcher
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var existingValue = Geo.defaultRadius
    switch searcher.params.aroundRadius {
      case let .explicit(value)?:
        existingValue = Double(value)
        break;
      default:
        break;
    }
    slider.value = CGFloat((existingValue - Geo.startRadius) / (Geo.endRadius - Geo.startRadius))
    slider.messageForValue = { [weak searcher] value in
      let meters = round(Geo.startRadius + Double(value) * (Geo.endRadius - Geo.startRadius))
      searcher?.params.aroundRadius = Query.AroundRadius.explicit(UInt(meters))
      let formatter = LengthFormatter()
      // When display in Km, we only want to display one digit
      return meters >= 1000 ? formatter.string(fromValue: round(meters / 100) / 10, unit: .kilometer) :
                               formatter.string(fromValue: meters, unit: .meter)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    searcher.search()
  }
}

extension RadiusController: KUIPopOverUsable {
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

