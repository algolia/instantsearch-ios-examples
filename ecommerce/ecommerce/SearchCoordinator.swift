//
//  SearchCoordinator.swift
//  ecommerce
//
//  Created by Guy Daher on 08/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import AlgoliaSearch

@objc protocol AlgoliaDataSource {
    @objc optional func handle(results: SearchResults, error: Error?)
    @objc optional func handle(hits: [JSONObject])
    @objc optional func handle(facets: [String: [FacetValue]])
}

class SearchCoordinator: NSObject, UISearchResultsUpdating, SearchProgressDelegate {
    var searcher: Searcher!
    var categoryFacets: [FacetValue] = []
    var hits: [JSONObject] = []
    
    let ALGOLIA_APP_ID = "latency"
    let ALGOLIA_INDEX_NAME = "bestbuy_promo"
    let ALGOLIA_API_KEY = Bundle.main.infoDictionary!["AlgoliaApiKey"] as! String
    var searchProgressController: SearchProgressController!
    
    var delegate: AlgoliaDataSource! // TODO: Might want to initialise this in the init method.
    
    init(searchController: UISearchController) {
        super.init()
        
        let client = Client(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY)
        let index = client.index(withName: ALGOLIA_INDEX_NAME)
        searcher = Searcher(index: index, resultHandler: self.handleResults)
        searcher.params.hitsPerPage = 15
        
        
        searchProgressController = SearchProgressController(searcher: searcher)
        searchController.searchResultsUpdater = self
        searchProgressController.delegate = self
        
        searcher.params.query = searchController.searchBar.text
        searcher.params.attributesToRetrieve = ["name", "manufacturer", "category", "salePrice", "bestSellingRank", "customerReviewCount", "image"]
        searcher.params.attributesToHighlight = ["name", "category"]
        searcher.params.facets = ["category"]
        searcher.search()
    }
    
    func loadMoreIfNecessary(rowNumber: Int) {
        // TODO: this '5' should be exposed as customisation
        if rowNumber + 5 >= hits.count {
            searcher.loadMore()
        }
    }
    
    func handleResults(results: SearchResults?, error: Error?) {
        guard let results = results else { return }
        if results.page == 0 {
            hits = results.hits
        } else {
            hits.append(contentsOf: results.hits)
        }
        
        delegate.handle?(results: results, error: error)
        delegate.handle?(hits: hits)
        categoryFacets = getFacets(with: results, andFacetName: "category")
        delegate.handle?(facets: ["category" : categoryFacets])
    }
    
    func getFacets(with results: SearchResults!, andFacetName facetName:String) -> [FacetValue] {
        // Sort facets: first selected facets, then by decreasing count, then by name.
        return FacetValue.listFrom(facetCounts: results.facets(name: facetName), refinements: searcher.params.buildFacetRefinements()[facetName]).sorted() { (lhs, rhs) in
            // When using cunjunctive faceting ("AND"), all refined facet values are displayed first.
            // But when using disjunctive faceting ("OR"), refined facet values are left where they are.
            let disjunctiveFaceting = results.disjunctiveFacets.contains(facetName)
            let lhsChecked = searcher.params.hasFacetRefinement(name: facetName, value: lhs.value)
            let rhsChecked = searcher.params.hasFacetRefinement(name: facetName, value: rhs.value)
            if !disjunctiveFaceting && lhsChecked != rhsChecked {
                return lhsChecked
            } else if lhs.count != rhs.count {
                return lhs.count > rhs.count
            } else {
                return lhs.value < rhs.value
            }
        }
    }
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        searcher.params.query = searchString
        searcher.search()
    }
    
    // MARK: - SearchProgressDelegate
    
    func searchDidStart(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func searchDidStop(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
