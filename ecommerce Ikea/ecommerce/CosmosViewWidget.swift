//
//  CosmosViewWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 6/16/17.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import Cosmos
import InstantSearch
import InstantSearchCore

private var xoAssociationKey: UInt8 = 0

extension CosmosView: AlgoliaWidget, SearchableViewModel {
    
    var searcher: Searcher! {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? Searcher
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func configure(with searcher: Searcher) {
        self.searcher = searcher
        didFinishTouchingCosmos = { rating in
            searcher.params.updateNumericRefinement("rating", .greaterThanOrEqual, NSNumber(value: rating))
            searcher.search()
        }
    }
}
