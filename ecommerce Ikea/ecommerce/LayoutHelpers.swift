//
//  LayoutHelpers.swift
//  ecommerce
//
//  Created by Guy Daher on 6/16/17.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

class LayoutHelpers {
    
    static func setupResultButton(button: UIButton) {
        button.backgroundColor = ColorConstants.barBackgroundColor
        button.setTitle("Fetching number of results...", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(ColorConstants.barTextColor, for: .normal)
    }
}
