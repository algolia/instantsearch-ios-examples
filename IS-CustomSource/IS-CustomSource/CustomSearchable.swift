//
//  CustomSearchable.swift
//  IS-CustomSource
//
//  Created by Robert Mogos on 06/10/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import Foundation
import AlgoliaSearch
import AFNetworking
import InstantSearchCore

public typealias SearchResultsHandler = (_ searchResults: SearchResults, _ error: Error?) -> Void

public protocol Transformer {
    // Transforms the Algolia params to custom backend params.
    func map(query: Query) -> Any
    
    // Transforms the custom backend result to an Algolia result.
    func map(result: Any) -> SearchResults
}

public protocol SearchTransformer: Transformer {
    // Search operation
    func search(_ query: Query, completionHandler: @escaping SearchResultsHandler)
}

//public class CustomBackend: Searchable {
////    typealias CustomQuery = String
////    typealias CustomSeachResults = String
//    let searchTransformer: SearchTransformer
//
//    init(searchTransformer: SearchTransformer) {
//        self.searchTransformer = searchTransformer
//    }
//
//    public func search(_ query: Query, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
//        let params = searchTransformer.map(query: query)
//        //searchTransformer.search(query, completionHandler: <#T##SearchResultsHandler##SearchResultsHandler##(SearchResults, Error?) -> Void#>)
//    }
//
//    public func searchDisjunctiveFaceting(_ query: Query, disjunctiveFacets: [String], refinements: [String : [String]], requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
//        return Operation()
//    }
//
//    public func searchForFacetValues(of facetName: String, matching text: String, query: Query?, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
//        return Operation()
//    }
//
//
//}


public class CustomSearchable:NSObject, Searchable {
  public func search(_ query: Query, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
    
    let operation = BlockOperation()
    
    operation.addExecutionBlock {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            guard let path = Bundle.main.path(forResource: "mock-custom", ofType: "json") else {
                print("Invalid filename/path.")
                return
            }
            do {
              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
              var jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
              
              let queryForCustomBackend = self.map(query: query) as! CustomSearchQuery
                
              guard let query = queryForCustomBackend.query else { return }
              
              jsonObj!["hitsCustom"] = (jsonObj!["hitsCustom"] as! [[String: String]]).filter({ item in
                (item["nameCustom"]?.contains(query))! || (item["descriptionCustom"]?.contains(query))!
                })
              
              let results = self.map(result: jsonObj!)
              var content = results.content
              content["hits"] = results.hits
              content["nbHits"] = results.nbHits
              
              completionHandler(content, nil)
            } catch let error {
              print(error.localizedDescription)
            }
          
        })
    }
    
    operation.start()
    return operation
  }
  
  public func searchDisjunctiveFaceting(_ query: Query, disjunctiveFacets: [String], refinements: [String : [String]], requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
    return Operation()
  }
  
  public func searchForFacetValues(of facetName: String, matching text: String, query: Query?, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
    return Operation()
  }
    
    // Transforms the custom backend result to an Algolia result.
    public func map(result: Any) -> SearchResults {
        let json = result as! [String: Any]
        
        let nbHitsCustom = json["nbHitsCustom"] as! Int
        let hitsCustom = json["hitsCustom"] as! [[String: Any]]
        let customSearchResults = CustomSearchResults(nbHits: nbHitsCustom, hits: hitsCustom)
        
        
        return SearchResults(nbHits: customSearchResults.nbHits, hits: customSearchResults.hits)
    }
    
    // Transforms the Algolia params to custom backend params.
    public func map(query: Query) -> Any {
        let queryText = query.query
        let filters = query.filters
        let facets = query.facets
        return CustomSearchQuery(query: queryText, filters: filters, facets: facets)
    }
}

public struct CustomSearchResults {
    var nbHits: Int
    var hits: [[String: Any]]
}

public struct CustomSearchQuery {
    var query: String?
    var filters: String?
    var facets: [String]?
}
