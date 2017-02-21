//
//  InstantSearchNumericFilters.swift
//  ecommerce
//
//  Created by Guy Daher on 20/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

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

enum NumericFilter {
    case int(Int) // Integer and FloatingPoint?
    case double(Double)
    case float(Float)
    case bool(Bool)
}

extension InstantSearch {
    func addWidget(numericFilter: IntegerValuable, forRefinement name: String) {
        self.numericFilters[name] = NumericFilter.int(numericFilter.value)
        reloadAllWidgets()
    }
    
    func addWidget(numericFilter: DoubleValuable, forRefinement name: String) {
        self.numericFilters[name] = NumericFilter.double(numericFilter.value)
        reloadAllWidgets()
    }
    
    func addWidget(numericFilter: FloatValuable, forRefinement name: String) {
        self.numericFilters[name] = NumericFilter.float(numericFilter.value)
        reloadAllWidgets()
    }
    
    func addWidget(numericFilter: BoolValuable, forRefinement name: String) {
        self.numericFilters[name] = NumericFilter.bool(numericFilter.value)
        reloadAllWidgets()
    }
    
    // TODO: Need to have setValueForWidget...
}
