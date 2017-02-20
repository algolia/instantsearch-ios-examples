//
//  InstantSearchStats.swift
//  ecommerce
//
//  Created by Guy Daher on 17/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

protocol InstantSearchStats {
    var text: String? { get set }
}

// TODO: UITextView also has a text property, but it is not optional.
// We can solve this by creating a new property nbHits that will change text, but
// will have to add stored property in order to achieve that.
extension UILabel: InstantSearchStats {}
extension UITextField: InstantSearchStats {}

extension InstantSearch {
    func addWidget(stats: InstantSearchStats) {
        self.stats.append(stats)
        reloadAllWidgets()
    }
}
