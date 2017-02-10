//
//  AlgoliaSearchManager.swift
//  ecommerce
//
//  Created by Guy Daher on 10/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import AlgoliaSearch

class AlgoliaSearchManager: AlgoliaSearchProtocol {
    /// The singleton instance.
    static let instance = AlgoliaSearchManager()
    
    let ALGOLIA_APP_ID = "latency"
    let ALGOLIA_INDEX_NAME = "bestbuy_promo"
    let ALGOLIA_API_KEY = Bundle.main.infoDictionary!["AlgoliaApiKey"] as! String
    
    var searcher: Searcher
    let index: Index
    
    private init() {
        let client = Client(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY)
        index = client.index(withName: ALGOLIA_INDEX_NAME)
        searcher = Searcher(index: index)
        searcher.params.hitsPerPage = 15
        searcher.params.attributesToRetrieve = ["name", "manufacturer", "category", "salePrice", "bestSellingRank", "customerReviewCount", "image"]
        searcher.params.attributesToHighlight = ["name", "category"]
        searcher.params.facets = ["category"]
        searcher.params.setFacet(withName: "category", disjunctive: true)
    }
}
