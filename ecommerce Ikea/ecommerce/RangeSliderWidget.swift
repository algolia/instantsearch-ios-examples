//
//  CosmosViewWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 6/16/17.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import Cosmos
import InstantSearch
import InstantSearchCore
import WARangeSlider

private var xoAssociationKey: UInt8 = 0

extension RangeSlider: AlgoliaWidget, SearchableViewModel {
    
    var searcher: Searcher! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? Searcher
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        minimumValue = 0
        maximumValue = 100
        self.addTarget(self, action: #selector(sliderValuesChanged), for: [.touchUpInside, .touchUpOutside])
        self.addTarget(RangeSliderViewController(), action: #selector(RangeSliderViewController.rangeSliderValueChanged), for: .valueChanged)
    }
    
    func sliderValuesChanged() {
        searcher.params.updateNumericRefinement("price", .greaterThanOrEqual, NSNumber(value: lowerValue))
        searcher.params.updateNumericRefinement("price", .lessThanOrEqual, NSNumber(value: upperValue))
        searcher.search()
    }
}
