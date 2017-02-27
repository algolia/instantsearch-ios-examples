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

class InstantSearchControl {
    // TODO: Make sure we really want to store this UIControl. If we can avoid that, it would be great (less dependencies :) )
    var control: UIControl
    var filterName: String?
    var op: NumericRefinement.Operator?
    var inclusive: Bool = true
    
    // TODO: That is an additional coupling... careful.
    var instantSearch: InstantSearch?
    
    // TODO: Make this debouncer customisable (expose it)
    internal var numericFiltersDebouncer = Debouncer(delay: 0.2)
    
    required init(_ control: UIControl) {
        self.control = control
        control.addTarget(self, action: #selector(numericFilterValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc internal func numericFilterValueChanged(sender: UIControl) {
        numericFiltersDebouncer.call {
            
            
            switch sender {
            case let slider as UISlider:
                // TODO: Don't force unwrap... fix that once POC is done.
                if let numericValue = self.instantSearch?.searcher.params.numericRefinements[self.filterName!]?.first(where: { $0.op == self.op! }) {
                    numericValue.value = NSNumber(value: slider.value)
                } else {
                    self.instantSearch?.searcher.params.addNumericRefinement(self.filterName!, self.op!, Double(slider.value))
                }
                
                self.instantSearch?.searcher.search()
                self.instantSearch?.reloadAllWidgets()
//            case let mySwitch as InstantSearchSwitch:
//                print(mySwitch.isOn)
//            case let stepper as InstantSearchStepper:
//                print(stepper.value)
//            case let segmentedControl as InstantSearchSegmentedControl:
//                print(segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!)
//            case let datePicker as InstantSearchDatePicker:
//                print(datePicker.date.timeIntervalSince1970)
            default: print("none!")
            }
        }
    }
}

//class InstantSearchSlider : UISlider, InstantSearchNumericFilter {
//    var filterName: String?
//    var op: NumericRefinement.Operator?
//    var inclusive: Bool = true
//}
//
//class InstantSearchStepper : UIStepper, InstantSearchNumericFilter {
//    var filterName: String?
//    var op: NumericRefinement.Operator?
//    var inclusive: Bool = true
//}
//
//class InstantSearchSwitch : UISwitch, InstantSearchNumericFilter {
//    var filterName: String?
//    var inclusive: Bool = true
//}
//
//class InstantSearchSegmentedControl : UISegmentedControl, InstantSearchNumericFilter {
//    var filterName: String?
//    var op: NumericRefinement.Operator?
//    var inclusive: Bool = true
//}
//
//class InstantSearchDatePicker : UIDatePicker, InstantSearchNumericFilter {
//    var filterName: String?
//    var op: NumericRefinement.Operator?
//    var inclusive: Bool = true
//}


extension InstantSearch {
    
    func addWidget(numericFilter: UIControl, withFilterName filterName: String, operation op: NumericRefinement.Operator?, inclusive: Bool = true) {
        
//        switch numericFilter {
//        case let slider as UISlider:
//            var instantSearchslider
//            
//        }
//      
        var instantSearchControl = InstantSearchControl(numericFilter)
        instantSearchControl.filterName = filterName
        instantSearchControl.op = op
        instantSearchControl.inclusive = inclusive
        instantSearchControl.instantSearch = self // TODO: Careful reference cycle!
        
        
        numericFilters.append(instantSearchControl)
        reloadAllWidgets()
    }
    
    // TODO: Change the filter value and trigger a search! 
//    internal func numericFilterValueChanged(sender: UIControl) {
//        numericFiltersDebouncer.call {
//            switch sender {
//            case let slider as InstantSearchSlider:
//                // TODO: Don't force unwrap... fix that once POC is done.
//                if let numericValue = self.searcher.params.numericRefinements[slider.filterName!]?.first(where: { $0.op == slider.op }) {
//                    numericValue.value = NSNumber(value: slider.value)
//                } else {
//                    self.searcher.params.addNumericRefinement(slider.filterName!, slider.op!, Double(slider.value))
//                }
//                
//                self.searcher.search()
//                self.reloadAllWidgets()
//            case let mySwitch as InstantSearchSwitch:
//                print(mySwitch.isOn)
//            case let stepper as InstantSearchStepper:
//                print(stepper.value)
//            case let segmentedControl as InstantSearchSegmentedControl:
//                print(segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!)
//            case let datePicker as InstantSearchDatePicker:
//                print(datePicker.date.timeIntervalSince1970)
//            default: print("none!")
//            }
//        }
//    }
    // TODO: Need to have setValueForWidget...
}
