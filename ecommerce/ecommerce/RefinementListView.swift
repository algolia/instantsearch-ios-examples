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
class RefinementListView: UITableView, AlgoliaWidget {
    private var searcher: Searcher!
    var facetDataSource: AlgoliaFacetDataSource?
    @IBInspectable var facet: String?
    
    func initWith(searcher: Searcher) {
        self.searcher = searcher
        delegate = self
        
        if let facet = facet, let results = searcher.results, let hits = searcher.hits, hits.count > 0 {
            let facetResults = searcher.getRefinementList(facetCounts: results.facets(name: facet), andFacetName: facet, transformRefinementList: .countDesc, areRefinedValuesFirst: true)
            
            facetDataSource?.handle(facetRecords: facetResults)
        }
    }
    
    func on(results: SearchResults?, error: Error?, userInfo: [String : Any]) {
        guard let facet = facet, searcher.params.hasFacetRefinements(name: facet) else { return }
        
        let facetResults = searcher.getRefinementList(facetCounts: results?.facets(name: facet), andFacetName: facet, transformRefinementList: .countDesc, areRefinedValuesFirst: true)
        
        facetDataSource?.handle(facetRecords: facetResults)
    }
    
    func onReset() {
        
    }
    
}

extension RefinementListView: UITableViewDelegate {
    
}

extension UITableViewDataSource {
    
    func internal_numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func internal_tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func internal_tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Whatever
        return UITableViewCell()
    }   
}
