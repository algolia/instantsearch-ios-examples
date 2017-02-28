//
//  InstantSearchClearFilters.swift
//  ecommerce
//
//  Created by Guy Daher on 17/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

let clearAllFiltersNotification = Notification.Name(rawValue: "clearAllFiltersNotification")

extension InstantSearch {
    func addWidget(clearFilter: UIControl, for controlEvent: UIControlEvents) {
        clearFilter.addTarget(self, action: #selector(self.clearFilter), for: controlEvent)
        reloadAllWidgets()
    }
    
    internal func clearFilter() {
        searcher.params.clearRefinements()
        NotificationCenter.default.post(name: clearAllFiltersNotification, object: nil)
        print("Button Pressed")
        searcher.search()
        reloadAllWidgets()
    }
}
