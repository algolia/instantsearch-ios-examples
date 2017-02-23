//
//  InstantSearchNumericFilters.swift
//  ecommerce
//
//  Created by Guy Daher on 20/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

extension InstantSearch {
    
    func addWidget(numericFilter: UIControl, forRefinement name: String) {
        //numericFilters[name] = NumericFilter.uiControl(numericFilter)
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
