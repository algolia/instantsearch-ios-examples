//
//  InstantSearchClearFilters.swift
//  ecommerce
//
//  Created by Guy Daher on 17/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

extension InstantSearch {
    func addWidget(clearFilter: UIButton) {
        clearFilters.append(clearFilter)
        clearFilter.addTarget(self, action: #selector(self.clearFilter), for: .touchUpInside)
    }
    
    internal func clearFilter() {
        searcher.params.clearRefinements()
        searcher.search()
        reloadAllWidgets()
    }
}
