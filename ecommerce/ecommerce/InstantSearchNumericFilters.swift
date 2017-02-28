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
typealias FacetFilterValueChanged = (UIControl,String,Bool) -> ()


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

class InstantSearchFacetControl {
    var control: UIControl
    var filterName: String
    var inclusive: Bool = true
    var valueChanged: FacetFilterValueChanged
    
    // TODO: Make this debouncer customisable (expose it)
    internal var numericFiltersDebouncer = Debouncer(delay: 0.2)
    
    required init(_ control: UIControl, _ filterName: String, _ valueChanged: @escaping FacetFilterValueChanged, inclusive: Bool = true) {
        self.control = control
        self.filterName = filterName
        self.inclusive = inclusive
        self.valueChanged = valueChanged
        control.addTarget(self, action: #selector(numericFilterValueChanged(sender:)), for: .valueChanged)
    }
    
    // TODO: Need to use weak self.
    @objc internal func numericFilterValueChanged(sender: UIControl) {
        numericFiltersDebouncer.call {
            self.valueChanged(sender, self.filterName, self.inclusive)
        }
    }
}

extension InstantSearch {
    
    // TODO: Can make 3 different ones for the different controls that we support. In that case, have control over safety since we know which UIControl we support.
    func addWidget(facetControl: UIControl, withFilterName filterName: String, inclusive: Bool = true) {
        let instantSearchControl = InstantSearchFacetControl(facetControl, filterName, facetFilterValueChanged, inclusive: inclusive)
        
        facetFilters.append(instantSearchControl)
        reloadAllWidgets()
    }
    
    internal func facetFilterValueChanged(_ control: UIControl, _ filterName: String, _ inclusive: Bool = true) {
        var value = String()
        
        switch control {
        case let slider as UISlider:
            value = String(slider.value)
        case let stepper as UIStepper:
            value = String(stepper.value)
        case let datePicker as UIDatePicker:
            value = String(datePicker.date.timeIntervalSince1970)
        case let mySwitch as UISwitch: // TODO: Accept param which changes the value on true or false?
            value = String(mySwitch.isOn)
        case let segmentedControl as UISegmentedControl:
            value = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!
        default: print("Control sent to InstantSearch is not supported, so nothing is updated")
            return
        }
        
        searcher.params.updateFacetRefinement(name: filterName, value: value, inclusive: inclusive)
        searcher.search()
        reloadAllWidgets()
    }
    
    func addWidget(numericControl: UIControl, withFilterName filterName: String, operation op: NumericRefinement.Operator, inclusive: Bool = true) {
        
        let instantSearchControl = InstantSearchNumericControl(numericControl, filterName, op, numericFilterValueChanged, inclusive: inclusive)
        
        numericFilters.append(instantSearchControl)
        reloadAllWidgets()
    }
    
    
    
    internal func numericFilterValueChanged(_ control:UIControl, _ filterName: String, _ op: NumericRefinement.Operator, _ inclusive: Bool = true) {
        var value = NSNumber()
        
        switch control {
        case let slider as UISlider:
            value = NSNumber(value:slider.value)
        case let stepper as UIStepper:
            value = NSNumber(value: stepper.value)
        case let datePicker as UIDatePicker:
            value = NSNumber(value: datePicker.date.timeIntervalSince1970)
//        case let mySwitch as UISwitch:
//            value = NSNumber(value: mySwitch.isOn)
            //        case let segmentedControl as UISegmentedControl:
            //            searcher.params.updateNumericRefinement(filterName, op, NSNumber(value: segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!))
        //            print(segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!)
        default: print("Control sent to InstantSearch is not supported, so nothing is updated")
            return
        }
        
        searcher.params.updateNumericRefinement(filterName, op, value, inclusive)
        searcher.search()
        reloadAllWidgets()
    }
    
    // TODO: Need to have setValueForWidget...
}

extension SearchParameters {
    func updateNumericRefinement(_ filterName: String, _ op: NumericRefinement.Operator, _ value: NSNumber, _ inclusive: Bool = true) {
        if let numericValue = numericRefinements[filterName]?.first(where: { $0.op == op }) { // TODO: Should we also check for inclusive value? same for facet refinements
            numericValue.value = value
        } else {
            addNumericRefinement(filterName, op, value, inclusive: inclusive)
        }
    }
    
    func updateFacetRefinement(name filterName: String, value: String, inclusive: Bool = true) {
        if let facetValue = facetRefinements[filterName]?.first {
            facetValue.value = value
        } else {
            addFacetRefinement(name: filterName, value: value, inclusive: inclusive)
        }
    }
}
