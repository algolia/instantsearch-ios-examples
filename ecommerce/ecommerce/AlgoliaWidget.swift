//
//  AlgoliaWidget.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

@objc protocol AlgoliaWidget: class {
    @objc func initWith(searcher: Searcher)
    @objc func on(results: SearchResults?, error: Error?, userInfo: [String: Any])
    @objc func onReset()
}

@objc protocol RefinementControlWidget: AlgoliaWidget {
    @objc func registerValueChangedAction()
    @objc optional func onRefinementChange(numerics: [String: [NumericRefinement]]?)
    @objc optional func onRefinementChange(facets: [String: [FacetRefinement]]?)
}
