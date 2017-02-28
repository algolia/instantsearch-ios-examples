//
//  InstantSearchNumericFilters.swift
//  ecommerce
//
//  Created by Guy Daher on 20/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import UIKit

protocol InstantSearchNumericFilter {
    var filterName: String? { get set }
    var inclusive: Bool { get set }
}

typealias NumericFilterValueChanged = (UIControl,String,NumericRefinement.Operator,Bool) -> ()

class InstantSearchNumericControl {
    var control: UIControl
    var filterName: String
    var op: NumericRefinement.Operator
    var inclusive: Bool = true
    var valueChanged: NumericFilterValueChanged
    
    // TODO: Make this debouncer customisable (expose it)
    internal var numericFiltersDebouncer = Debouncer(delay: 0.2)
    
    required init(_ control: UIControl, _ filterName: String, _ op: NumericRefinement.Operator, _ valueChanged: @escaping NumericFilterValueChanged, inclusive: Bool = true) {
        self.control = control
        self.filterName = filterName
        self.op = op
        self.inclusive = inclusive
        self.valueChanged = valueChanged
        control.addTarget(self, action: #selector(numericFilterValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc internal func numericFilterValueChanged(sender: UIControl) {
        numericFiltersDebouncer.call {
            self.valueChanged(sender, self.filterName, self.op, self.inclusive)
        }
    }
}

extension InstantSearch {
    
    func addWidget(facetControl: UIControl, withFilterName filterName: String, inclusive: Bool = true) {
        
    }
    
    func addWidget(numericControl: UIControl, withFilterName filterName: String, operation op: NumericRefinement.Operator, inclusive: Bool = true) {
        
        let instantSearchControl = InstantSearchNumericControl(numericControl, filterName, op, numericFilterValueChanged, inclusive: inclusive)
        
        numericFilters.append(instantSearchControl)
        reloadAllWidgets()
    }
    
    internal func numericFilterValueChanged(_ control:UIControl, _ filterName: String, _ op: NumericRefinement.Operator, _ inclusive: Bool) {
        switch control {
        case let slider as UISlider:
            // TODO: Don't force unwrap... fix that once POC is done.
            if let numericValue = self.searcher.params.numericRefinements[filterName]?.first(where: { $0.op == op }) {
                numericValue.value = NSNumber(value: slider.value)
            } else {
                self.searcher.params.addNumericRefinement(filterName, op, Double(slider.value))
            }
            
            self.searcher.search()
            self.reloadAllWidgets()
//        case let mySwitch as InstantSearchSwitch:
//            print(mySwitch.isOn)
//        case let stepper as InstantSearchStepper:
//            print(stepper.value)
//        case let segmentedControl as InstantSearchSegmentedControl:
//            print(segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!)
//        case let datePicker as InstantSearchDatePicker:
//            print(datePicker.date.timeIntervalSince1970)
        default: print("none!")
        }
    }
    
    // TODO: Need to have setValueForWidget...
}
