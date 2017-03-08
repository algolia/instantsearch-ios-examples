//
//  Slider.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

@objc class Slider: NSObject, RefinementControlWidget {
    
    var searcher: Searcher?
    var valueLabel: UILabel?
    var slider: UISlider
    
    private var attributeName: String
    private var operation: NumericRefinement.Operator
    private var inclusive: Bool
    
    // TODO: Make this debouncer customisable (expose it)
    internal var numericFiltersDebouncer = Debouncer(delay: 0.2)
    
    init(slider: UISlider, valueLabel: UILabel? = nil, attributeName: String, operation: NumericRefinement.Operator, inclusive: Bool = true) {
        self.slider = slider
        self.valueLabel = valueLabel
        self.attributeName = attributeName
        self.operation = operation
        self.inclusive = inclusive
    }
    
    @objc func initWith(searcher: Searcher) {
        self.searcher = searcher
    }
    
    @objc func registerValueChangedAction() {
        slider.addTarget(self, action: #selector(numericFilterValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc internal func numericFilterValueChanged(sender: UISlider) {
        numericFiltersDebouncer.call {
            self.searcher?.params.updateNumericRefinement(self.attributeName, self.operation, NSNumber(value: sender.value))
            self.searcher?.search()
        }
    }
    
    @objc func getAttributeName() -> String {
        return attributeName
    }
    
    @objc func onRefinementChange(numerics: [NumericRefinement]) {
        for numeric in numerics {
            if numeric.op == operation {
                slider.setValue(numeric.value.floatValue, animated: false)
                 // TODO: Offer customisation and reevaluate if label is best choice
                valueLabel?.text = "\(numeric.value)"
            }
        }
    }
    
    @objc func onReset() {
        slider.setValue(slider.minimumValue, animated: false)
        // TODO: Is minimum the right choice? maybe we want max to be default! think about it...
        valueLabel?.text = "\(slider.minimumValue)"
    }
    
    @objc func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        
    }
}
