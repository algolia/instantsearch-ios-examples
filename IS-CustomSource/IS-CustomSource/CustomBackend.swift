//
//  CustomBackend.swift
//  IS-CustomSource
//
//  Created by Guy Daher on 04/04/2018.
//  Copyright © 2018 Robert Mogos. All rights reserved.
//

import Foundation
import InstantSearch
import Alamofire

public class CustomBackendProducts: SearchClient<CustomBackendParameters, CustomBackendResults> {
    
    public override func map(query: Query) -> CustomBackendParameters {
        let queryText = query.query ?? ""
        let hpp = query.hitsPerPage ?? 3
        
        return CustomBackendParameters(query: queryText, hitsPerPage: hpp)
    }
    
    public override func map(results: CustomBackendResults) -> SearchResults {
        
        return try! SearchResults(content: results.products, disjunctiveFacets: [])
    }
    
    public override func search(_ query: CustomBackendParameters, searchResultsHandler: @escaping (CustomBackendResults?, Error?) -> Void) {
        Alamofire.request("http://localhost:3000/api/v1/users/search").responseJSON { responseJson in
            
            let result = responseJson.result
            
            if let json = result.value as? [String: Any] {
                let movie = json["movie"] as! [String: Any]
                let products = json["products"] as! [String: Any]
                
                let customBackendResults = CustomBackendResults(content: json, movie: movie, products: products)
                
                searchResultsHandler(customBackendResults, nil)
                
            }
            
        }
    }
    
}

public class CustomBackendMovies: SearchClient<CustomBackendParameters, CustomBackendResults> {
    
    public override func map(query: Query) -> CustomBackendParameters {
        let queryText = query.query ?? ""
        let hpp = query.hitsPerPage ?? 3
        
        return CustomBackendParameters(query: queryText, hitsPerPage: hpp)
    }
    
    public override func map(results: CustomBackendResults) -> SearchResults {
        
        return try! SearchResults(content: results.movie, disjunctiveFacets: [])
    }
    
    public override func search(_ query: CustomBackendParameters, searchResultsHandler: @escaping (CustomBackendResults?, Error?) -> Void) {
        Alamofire.request("http://localhost:3000/api/v1/users/search").responseJSON { responseJson in
            
            let result = responseJson.result
            
            if let json = result.value as? [String: Any] {
                let movie = json["movie"] as! [String: Any]
                let products = json["products"] as! [String: Any]
                
                let customBackendResults = CustomBackendResults(content: json, movie: movie, products: products)
                
                searchResultsHandler(customBackendResults, nil)
                
            }
            
        }
    }
    
}

public struct CustomBackendParameters {
    let query: String
    let hitsPerPage: UInt
}

public struct CustomBackendResults {
    let content: [String: Any]
    let movie: [String: Any]
    let products: [String: Any]
}
