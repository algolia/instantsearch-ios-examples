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

// POC 1

public protocol SearchableAndTransformable: Searchable {
    associatedtype IResults
    associatedtype IParameters
    
    typealias SearchResultsHandler = (_ results: IResults?, _ error: Error?) -> Void
    
    // Search operation
    func search(_ query: IParameters, searchResultsHandler: @escaping SearchResultsHandler) -> Operation
    
    // Transforms the Algolia params to custom backend params.
    func map(query: Query) -> IParameters
    
    // Transforms the custom backend result to an Algolia result.
    func map(result: IResults) -> SearchResults
}

open class SearchTransformer<Parameters, Results>: SearchableAndTransformable {
    public typealias IParameters = Parameters
    public typealias IResults = Results
    
    open func search(_ query: Parameters, searchResultsHandler: @escaping SearchResultsHandler) -> Operation {
        fatalError("make sure to override search(query:searchResultsHandler:) for custom backend")
    }
    
    open func map(query: Query) -> Parameters {
        fatalError("make sure to override map(query:) for custom backend")
    }
    
    open func map(result: Results) -> SearchResults {
        fatalError("make sure to override map(result:) for custom backend")
    }
    
    public func search(_ query: Query, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        let params = self.map(query: query)
        let operation = self.search(params) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let result = result {
                let searchResults = self.map(result: result)
                
                // potentially, instead of th Query class, we can use the SearchResults class and avoid doing this conversion.
                var content = searchResults.content
                content["hits"] = searchResults.hits
                content["nbHits"] = searchResults.nbHits
                
                completionHandler(content, nil)
            }
        }
        
        return operation
    }
    
    // TODO same idea as the search above
    public func searchDisjunctiveFaceting(_ query: Query, disjunctiveFacets: [String], refinements: [String : [String]], requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        return Operation()
    }
    
    // TODO same idea as the search above
    public func searchForFacetValues(of facetName: String, matching text: String, query: Query?, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        return Operation()
    }
}


// POC 2 ------------------------------------------------------------
// Downside: a lot of uses of `Any` since we hit a limitation of Swift: when using protocol as a class member, we can't use generics.
// This is will lead to a lot of type casting which means less safety and can lead to bugs.

public typealias SearchAnyResultsHandler = (_ results: Any?, _ error: Error?) -> Void

public protocol Transformable {
    // Transforms the Algolia params to custom backend params.
    func map(query: Query) -> Any
    
    // Transforms the custom backend result to an Algolia result.
    func map(result: Any) -> SearchResults
}

public protocol SearchTransformable: Transformable {
    // Search operation
    func search(_ query: Any, searchResultsHandler: @escaping SearchAnyResultsHandler) -> Operation
}

public class CustomSearchable: Searchable {
    // IMPORTANT: here the 3rd party dev injects his custom searchTransformable
    let searchTransformer: SearchTransformable
    
    init(searchTransformer: SearchTransformable) {
        self.searchTransformer = searchTransformer
    }
    
    public func search(_ query: Query, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        let params = searchTransformer.map(query: query)
        let operation = searchTransformer.search(params) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let result = result {
                let searchResults = self.searchTransformer.map(result: result)
                
                // potentially, instead of th Query class, we can use the SearchResults class and avoid doing this conversion.
                var content = searchResults.content
                content["hits"] = searchResults.hits
                content["nbHits"] = searchResults.nbHits
                
                completionHandler(content, nil)
            }
        }
        
        return operation
    }
    
    // TODO same idea as the search above
    public func searchDisjunctiveFaceting(_ query: Query, disjunctiveFacets: [String], refinements: [String : [String]], requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        return Operation()
    }
    
    // TODO same idea as the search above
    public func searchForFacetValues(of facetName: String, matching text: String, query: Query?, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        return Operation()
    }
}
