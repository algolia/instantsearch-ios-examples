//
//  InstantSearchNumericFilters.swift
//  ecommerce
//
//  Created by Guy Daher on 20/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

// TODO: This is not exhaustive ofc... There are a lot of other specific ones.
// For prototyping it s fine now, but need more generic way later on.
protocol IntegerValuable {
    var value: Int { get set }
}

protocol DoubleValuable {
    var value: Double { get set }
}

protocol FloatValuable {
    var value: Float { get set }
}

protocol BoolValuable {
    var value: Bool { get set }
}

protocol NSNumberValuable {
    var value: NSNumber { get set }
}

enum NumericFilter {
    case int(Int) // Integer and FloatingPoint?
    case double(Double)
    case float(Float)
    case bool(Bool)
    case nsNumber(NSNumber)
    case uiControl(UIControl)
}

extension InstantSearch {
    func addWidget(numericFilter: IntegerValuable, forRefinement name: String) {
        numericFilters[name] = NumericFilter.int(numericFilter.value)
        reloadAllWidgets()
    }
    
    func addWidget(numericFilter: DoubleValuable, forRefinement name: String) {
        numericFilters[name] = NumericFilter.double(numericFilter.value)
        reloadAllWidgets()
    }
    
    func addWidget(numericFilter: FloatValuable, forRefinement name: String) {
        numericFilters[name] = NumericFilter.float(numericFilter.value)
        reloadAllWidgets()
    }
    
    func addWidget(numericFilter: BoolValuable, forRefinement name: String) {
        numericFilters[name] = NumericFilter.bool(numericFilter.value)
        reloadAllWidgets()
    }
    
    func addWidget(numericFilter: NSNumberValuable, forRefinement name: String) {
        numericFilters[name] = NumericFilter.nsNumber(numericFilter.value)
        reloadAllWidgets()
    }
    
    func addWidget(numericFilter: UIControl, forRefinement name: String) {
        numericFilters[name] = NumericFilter.uiControl(numericFilter)
        numericFilter.addTarget(self, action: #selector(numericFilterValueChanged(sender:)), for: .valueChanged)
        reloadAllWidgets()
    }
    
    // TODO: Change the filter value and trigger a search! 
    internal func numericFilterValueChanged(sender: UIControl) {
        switch sender {
        case let slider as UISlider:
            print(slider.value)
        case let mySwitch as UISwitch:
            print(mySwitch.isOn)
        case let stepper as UIStepper:
            print(stepper.value)
        case let segmentedControl as UISegmentedControl:
            print(segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)!)
        case let datePicker as UIDatePicker:
            print(datePicker.date.timeIntervalSince1970)
        default: print("none!")
        }

    }
    // TODO: Need to have setValueForWidget...
}
