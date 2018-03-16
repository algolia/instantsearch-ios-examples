//
//  CustomSearchableImplementation.swift
//  IS-CustomSource
//
//  Created by Guy Daher on 12/03/2018.
//  Copyright © 2018 Robert Mogos. All rights reserved.
//

import Foundation
import AlgoliaSearch
import InstantSearchCore

// Search Data Models of the custom backend

public struct CustomSearchResults {
    var nbHitsCustom: Int
    var hitsCustom: [[String: Any]]
}

public struct CustomSearchParameters {
    var query: String?
    var filters: String?
    var facets: [String]?
}

public class CustomSearchableImplementation: SearchTransformer<CustomSearchParameters, CustomSearchResults> {
    
    public override func search(_ query: CustomSearchParameters, searchResultsHandler: @escaping SearchResultsHandler) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            guard let path = Bundle.main.path(forResource: "mock-custom", ofType: "json") else {
                print("Invalid filename/path.")
                return
            }
            do {
                guard let text = query.query else { return }
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                var jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                jsonObj!["hitsCustom"] = (jsonObj!["hitsCustom"] as! [[String: String]]).filter({ item in
                    (item["nameCustom"]?.contains(text))! || (item["descriptionCustom"]?.contains(text))!
                })
                let nbHitsCustom = jsonObj!["nbHitsCustom"] as! Int
                let hitsCustom = jsonObj!["hitsCustom"] as! [[String: Any]]
                let customSearchResults = CustomSearchResults(nbHitsCustom: nbHitsCustom, hitsCustom: hitsCustom)
                
                // IMPORTANT: Need to call the searchResultHandler when done, this is the responsibility of the 3rd party dev
                searchResultsHandler(customSearchResults, nil)
            } catch let error {
                searchResultsHandler(nil, error)
                print(error.localizedDescription)
            }
            
        })
        
    }
    
    public override func map(query: Query?, facetName: String, matching text: String) -> CustomSearchParameters {
        return CustomSearchParameters(query: text, filters: facetName, facets: nil)
    }
    
    // Transforms the Algolia params to custom backend params.
    public override func map(query: Query) -> CustomSearchParameters {
        let queryText = query.query
        let filters = query.filters
        let facets = query.facets
        
        return CustomSearchParameters(query: queryText, filters: filters, facets: facets)
    }
    
    // Transforms the custom backend result to an Algolia result.
    public override func map(results: CustomSearchResults) -> SearchResults {
        let nbHitsCustom = results.nbHitsCustom
        let hitsCustom = results.hitsCustom
        
        return SearchResults(nbHits: nbHitsCustom, hits: hitsCustom)
    }
}
