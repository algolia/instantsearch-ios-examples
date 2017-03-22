//
//  RefinementList.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

@IBDesignable
class RefinementListView: UITableView, AlgoliaWidget, AlgoliaFacetDataSource2, AlgoliaFacetDelegate {
    private var searcher: Searcher!
    @IBInspectable var facet: String = ""
    @IBInspectable var areRefinedValuesFirst: Bool = true
    @IBInspectable var isDisjunctive: Bool = true
    
    var facetResults: [FacetValue] = []
    
    func initWith(searcher: Searcher) {
        self.searcher = searcher
        
        // TODO: Make the countDesc and refinedFirst customisable ofc. 
        if let results = searcher.results, let hits = searcher.hits, hits.count > 0 {
            facetResults = searcher.getRefinementList(facetCounts: results.facets(name: facet), andFacetName: facet, transformRefinementList: .countDesc, areRefinedValuesFirst: areRefinedValuesFirst)
            
            reloadData()
        }
    }
    
    func on(results: SearchResults?, error: Error?, userInfo: [String : Any]) {
            // TODO: Fix that cause for some reason, can't find the facet refinement.
            //,searcher.params.hasFacetRefinements(name: facet)
            // else { return }
        
        facetResults = searcher.getRefinementList(facetCounts: results?.facets(name: facet), andFacetName: facet, transformRefinementList: .countDesc, areRefinedValuesFirst: areRefinedValuesFirst)
        reloadData()
    }
    
    func onReset() {
        
    }
    
    func numberOfRows(in section: Int) -> Int {
        return searcher.results?.facets(name: facet)?.count ?? 0
    }
    
    func facetForRow(at indexPath: IndexPath) -> FacetValue {
        return facetResults[indexPath.row]
    }
    
    func isRefined(at indexPath: IndexPath) -> Bool {
        return searcher.params.hasFacetRefinement(name: facet, value: facetResults[indexPath.item].value)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        searcher.params.toggleFacetRefinement(name: facet, value: facetResults[indexPath.item].value)
        searcher.params.setFacet(withName: facet, disjunctive: isDisjunctive)
        searcher.search()
    }
}

protocol AlgoliaFacetDataSource2 {
    func numberOfRows(in section: Int) -> Int
    func facetForRow(at indexPath: IndexPath) -> FacetValue
    func isRefined(at indexPath: IndexPath) -> Bool
}

protocol AlgoliaFacetDelegate {
    func didSelectRow(at indexPath: IndexPath)
}
