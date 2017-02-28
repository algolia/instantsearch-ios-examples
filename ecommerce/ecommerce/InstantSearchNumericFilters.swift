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
        // TODO: Will be able to remove that control (and in facetFilters) since just use notifications and target action to react to things.
        self.control = control
        self.filterName = filterName
        self.op = op
        self.inclusive = inclusive
        self.valueChanged = valueChanged
        control.addTarget(self, action: #selector(numericFilterValueChanged(sender:)), for: .valueChanged)
        control.clearInstantSearchFilter()
    }
    
    @objc internal func numericFilterValueChanged(sender: UIControl) {
        numericFiltersDebouncer.call {
            self.valueChanged(sender, self.filterName, self.op, self.inclusive)
        }
    }
}

extension UIControl {
    func clearInstantSearchFilter() {
        // TODO: should we use nil for queue (OperationQueue) synchronous or not? Check..
        NotificationCenter.default.addObserver(forName: clearAllFiltersNotification, object: nil, queue: nil, using: clearControl)
    }
    
    open func clearControl(notification: Notification) {}
}

extension UISlider {
    override open func clearControl(notification: Notification) {
        setValue(minimumValue, animated: true)
        sendActions(for: .valueChanged)
    }
}

extension InstantSearch {
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
        default: print("Control sent to InstantSearch is not supported, so nothing is updated")
            return
        }
        
        searcher.params.updateNumericRefinement(filterName, op, value, inclusive)
        searcher.search()
        reloadAllWidgets()
    }
}

extension SearchParameters {
    func updateNumericRefinement(_ filterName: String, _ op: NumericRefinement.Operator, _ value: NSNumber, _ inclusive: Bool = true) {
        if let numericValue = numericRefinements[filterName]?.first(where: { $0.op == op }) { // TODO: Should we also check for inclusive value? same for facet refinements
            numericValue.value = value
        } else {
            addNumericRefinement(filterName, op, value, inclusive: inclusive)
        }
    }
}
