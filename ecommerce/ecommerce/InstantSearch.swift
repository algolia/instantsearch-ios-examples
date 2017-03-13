//
//  InstantSearch.swift
//  ecommerce
//
//  Created by Guy Daher on 08/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import AlgoliaSearch

@objc protocol AlgoliaHitDataSource {
    @objc optional func handle(results: SearchResults, error: Error?)
    func handle(hits: [JSONObject])
}

@objc protocol AlgoliaFacetDataSource {
    @objc optional func handle(results: SearchResults, error: Error?)
    func handle(facetRecords: [FacetValue]?)
}

//TODO: Make all private methods method..
class InstantSearch: NSObject, UISearchResultsUpdating, UISearchControllerDelegate, SearchProgressDelegate {

    // MARK: Members: Algolia Specific
    var searcher: Searcher!
    var instantSearchParameters = InstantSearchParameters()
    var facetResults: [String: [FacetValue]] = [:]
    //TODO: Is allHits still needed? since we have it in results..
    internal var allHits: [JSONObject] = []
    internal var results: SearchResults?
    
    // TODO: Can have a 2D array of widgets, which has all the below widgets.
    internal var hits: [HitsWidget?] = []
    internal var numericFilters: [InstantSearchNumericControl?] = []
    internal var facetFilters: [InstantSearchFacetControl?] = []
    
    // MARK: Members: Delegate
    
    var hitDataSource: AlgoliaHitDataSource? // TODO: Might want to initialise this in the init method.
    var facetDataSource: AlgoliaFacetDataSource?
    
    // MARK: Members: Controller
    
    var searchProgressController: SearchProgressController!
    
    var hitSearchController: UISearchController! {
        didSet {
            hitSearchController.searchResultsUpdater = self
            hitSearchController.delegate = self
        }
    }
    
    var facetSearchController: UISearchController! {
        didSet {
            facetSearchController.searchResultsUpdater = self
        }
    }
    
    // MARK: Init setters and getters
    
    init(algoliaSearchProtocol: InstantSearchProtocol, searchController: UISearchController) {
        super.init()

        instantSearchParameters = algoliaSearchProtocol.instantSearchParameters
        searcher = algoliaSearchProtocol.searcher
        searcher.addResultHandler(self.handleResults)
        
        searchProgressController = SearchProgressController(searcher: searcher)
        searchProgressController.delegate = self
        
        searcher.params.query = ""
        searcher.search()
        
        defer {
            hitSearchController = searchController
        }
    }
    
    func reloadAllWidgets() {
        guard let results = results else { return }
        
        for hit in hits {
            hit?.reloadData()
        }
    }
    
    func set(facetSearchController: UISearchController) {
        self.facetSearchController = facetSearchController
    }
    
    // This comes from Searcher.searchForFacetValues.
    // TODO: Change naming because it is confusing. Also do a small diagram of the flow to visualise all these functions and delegates.
    func getFacetRecords(with results: SearchResults?, facetCounts: [String: Int]?, andFacetName facetName:String) -> [FacetValue]? {
        // Sort facets: first selected facets, then by decreasing count, then by name.
        let facetValues = FacetValue.listFrom(facetCounts: facetCounts, refinements: searcher.params.buildFacetRefinements()[facetName]).sorted() { (lhs, rhs) in
            // TODO: Change to false always. Need to decide on that later on.
            // When using cunjunctive faceting ("AND"), all refined facet values are displayed first.
            // But when using disjunctive faceting ("OR"), refined facet values are left where they are.
            let disjunctiveFaceting = false
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
        
        facetResults[facetName] = facetValues
        
        return facetResults[facetName]
    }
    
    // This comes from Searcher.search() results
    func getSearchFacetRecords(withFacetName facetName: String)  -> [FacetValue]? {
        return facetResults[facetName]
    }
    
    // Searcher Delegate functions
    
    func handleResults(results: SearchResults?, error: Error?, userInfo: JSONObject) {
        guard let results = results else { return }
        
        let isLoadingMore = userInfo[Searcher.notificationIsLoadingMoreKey] as? Bool
        //print(isLoadingMore)
        //print(searcher.hits?.count)
        
        self.results = results
        
        if results.page == 0 {
            allHits = results.hits
        } else {
            allHits.append(contentsOf: results.hits)
        }
        
        if let facets = searcher.params.facets {
            for facet in facets {
                facetResults[facet] = searcher.getRefinementList(facetCounts: results.facets(name: facet), andFacetName: facet, transformRefinementList: .countDesc, areRefinedValuesFirst: true)
            }
        }
        
        hitDataSource?.handle?(results: results, error: error)
        hitDataSource?.handle(hits: allHits)
        facetDataSource?.handle?(results: results, error: error)
        facetDataSource?.handle(facetRecords: facetResults["category"]!)
        facetSearchController?.searchBar.text = ""
        
        reloadAllWidgets()
    }
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        switch searchController {
        case hitSearchController:
            searcher.params.query = searchString
            searcher.search()
        case facetSearchController:
            if (searchString.isEmpty) {
                self.facetDataSource?.handle(facetRecords: getSearchFacetRecords(withFacetName: "category"))
                break
            }
            searcher.searchForFacetValues(of: "category", matching: searchString) {
                content, error in
                let facetHits = content?["facetHits"] as? [[String: Any]]
                var facetCounts: [String: Int] = [:]
                _ = facetHits?.map { (facetHit) in
                    let facetRecord = FacetResults(json: facetHit)
                    facetCounts[facetRecord.value!] = facetRecord.count
                }
                
                self.facetResults["category"] = self.searcher.getRefinementList(facetCounts: facetCounts, andFacetName: "category", transformRefinementList: .countDesc, areRefinedValuesFirst: false)
                
                self.facetDataSource?.handle(facetRecords: self.facetResults["category"])
            }
        default: break
        }
    }
    
    // MARK: UISearchControllerDelegate functions 
    
    func willPresentSearchController(_ searchController: UISearchController) {
        for hit in hits {
            hit?.scrollToFirstRow()
        }
    }
    
    
    func willDismissSearchController(_ searchController: UISearchController) {
        for hit in hits {
            hit?.scrollToFirstRow()
        }
    }
    // MARK: Search Helper Functions
    
    func loadMoreIfNecessary(rowNumber: Int) {
        if rowNumber + instantSearchParameters.remainingItemsBeforeLoading >= allHits.count {
            searcher.loadMore()
        }
    }
    
    func prefetchMoreIfNecessary(indexPaths: [IndexPath]) {
        let lastRowNumberToFetchOptional = indexPaths.map { $0.row }.max()
        
        guard let lastRowNumberToFetch = lastRowNumberToFetchOptional else {
            print("woah")
            return
        }
        
        if lastRowNumberToFetch >= allHits.count {
            searcher.loadMore()
            return
        }
    }
    
    func toggleFacetRefinement(name: String, value: String) {
        searcher.params.toggleFacetRefinement(name: name, value: value)
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
