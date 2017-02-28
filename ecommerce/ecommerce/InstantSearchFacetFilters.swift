//
//  InstantSearchFacetFilters.swift
//  ecommerce
//
//  Created by Guy Daher on 28/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

typealias FacetFilterValueChanged = (UIControl,String,Bool) -> ()

class InstantSearchFacetControl {
    var control: UIControl
    var filterName: String
    var inclusive: Bool = true
    var valueChanged: FacetFilterValueChanged
    
    required init(_ control: UIControl, _ filterName: String, _ valueChanged: @escaping FacetFilterValueChanged, inclusive: Bool = true) {
        self.control = control
        self.filterName = filterName
        self.inclusive = inclusive
        self.valueChanged = valueChanged
        control.addTarget(self, action: #selector(numericFilterValueChanged(sender:)), for: .valueChanged)
    }
    
    // TODO: Need to use weak self.
    @objc internal func numericFilterValueChanged(sender: UIControl) {
        self.valueChanged(sender, self.filterName, self.inclusive)
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
}


extension SearchParameters {
    func updateFacetRefinement(name filterName: String, value: String, inclusive: Bool = true) {
        if let facetValue = facetRefinements[filterName]?.first {
            facetValue.value = value
        } else {
            addFacetRefinement(name: filterName, value: value, inclusive: inclusive)
        }
    }
}
