//
//  FoundationHelpers.swift
//  ecommerce
//
//  Created by Guy Daher on 6/16/17.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
