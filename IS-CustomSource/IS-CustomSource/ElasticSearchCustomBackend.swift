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
import Alamofire

// Search Data Models of the custom backend

public struct SomeSearchParameters {
    var q: String?
}

public struct SomeSearchResults {
    var total: Int
    var hits: [[String: Any]]
}

public class SomeImplementation: SearchTransformer<SomeSearchParameters, SomeSearchResults> {
    
    public override func search(_ query: SomeSearchParameters, searchResultsHandler: @escaping SearchResultsHandler) {
        
        let user = "3nmp9kz7fh"
        let password = "gch2ewzerx"
        
        var headers: HTTPHeaders = [:]
        
        guard let authorizationHeader = Request.authorizationHeader(user: user, password: password) else {
            print("auth header wrong")
            return
        }
        
        headers[authorizationHeader.key] = authorizationHeader.value
        let queryText = query.q ?? ""
        
        Alamofire.request("https://tests-first-sandbox-9472672183.eu-west-1.bonsaisearch.net/concerts/_search?q=\(queryText)&pretty", headers: headers).responseJSON { responseJson in
            
            let result = responseJson.result
            print(result)
            
            if let json = result.value as? [String: Any] {
                let hitsJson = json["hits"] as! [String: Any]
                let total = hitsJson["total"] as! Int
                let hits = hitsJson["hits"] as! [[String: Any]]

                print("Total: \(total)")
                print("hits: \(hits)")
                
                let someSearchResults = SomeSearchResults(total: total, hits: hits)
                searchResultsHandler(someSearchResults, nil)
            }
        }
        
    }
    
    // Transforms the Algolia params to custom backend params.
    public override func map(query: Query) -> SomeSearchParameters {
        let searchParameters = query as! SearchParameters
        let facetRefinements = searchParameters.facetRefinements
        let numericRefinements = searchParameters.numericRefinements
        let queryText = query.query
        
        return SomeSearchParameters(q: queryText)
    }
    
    // Transforms the custom backend result to an Algolia result.
    public override func map(results: SomeSearchResults) -> SearchResults {
        let nbHits = results.total
        let hits = results.hits
        let categoryFacet = ["chairs": 10, "tables": 15]
        let facets = ["category": categoryFacet]
        let extraContent = ["facets": facets]
        
        // If want to add facets, needs to add it to the content
        
        return SearchResults(nbHits: nbHits, hits: hits, extraContent: extraContent)
    }
}

