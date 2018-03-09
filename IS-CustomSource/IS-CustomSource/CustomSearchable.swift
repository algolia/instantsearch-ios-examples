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

public typealias SearchResultsHandler = (_ results: Any?, _ error: Error?) -> Void

public protocol ISearchableTransformer: Searchable {
    associatedtype IResults
    associatedtype IParametters
    
    typealias SearchResultsHandler2 = (_ results: IResults?, _ error: Error?) -> Void
    
    // Search operation
    func search(_ query: IParametters, searchResultsHandler: @escaping SearchResultsHandler2) -> Operation
    
    // Transforms the Algolia params to custom backend params.
    func map(query: Query) -> IParametters
    
    // Transforms the custom backend result to an Algolia result.
    func map(result: IResults) -> SearchResults
}

open class SearchableTransformer<Parameters, Results>: ISearchableTransformer {
    public typealias IParametters = Parameters
    public typealias IResults = Results
    
    open func search(_ query: Parameters, searchResultsHandler: @escaping SearchResultsHandler2) -> Operation {
        fatalError("make sure to override search for custom backend")
    }
    
    open func map(query: Query) -> Parameters {
        fatalError("make sure to override map(query:) for custom backend")
    }
    
    open func map(result: Results) -> SearchResults {
        fatalError("make sure to override map(result:) for custom backend")
    }
    
    public func search(_ query: Query, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        let params = map(query: query)
        let operation = search(params) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let result = result {
                let searchResults = self.map(result: result)
                var content = searchResults.content
                content["hits"] = searchResults.hits
                content["nbHits"] = searchResults.nbHits
                
                completionHandler(content, nil)
            }
        }
        
        return operation
    }
    
    // TODO
    public func searchDisjunctiveFaceting(_ query: Query, disjunctiveFacets: [String], refinements: [String : [String]], requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        return Operation()
    }
    
    // TODO
    public func searchForFacetValues(of facetName: String, matching text: String, query: Query?, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        return Operation()
    }
}

public class CustomSearchable: SearchableTransformer<CustomSearchQuery, CustomSearchResults> {
    public override func search(_ query: CustomSearchQuery, searchResultsHandler: @escaping SearchResultsHandler2) -> Operation {
        let operation = BlockOperation()
        
        operation.addExecutionBlock {
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
                    let customSearchResults = CustomSearchResults(nbHits: nbHitsCustom, hits: hitsCustom)
                    
                    searchResultsHandler(customSearchResults, nil)
                } catch let error {
                    print(error.localizedDescription)
                }
                
            })
        }
        
        operation.start()
        return operation
    }
    
    // Transforms the Algolia params to custom backend params.
    public override func map(query: Query) -> CustomSearchQuery {
        let queryText = query.query
        let filters = query.filters
        let facets = query.facets
        return CustomSearchQuery(query: queryText, filters: filters, facets: facets)
    }
    
    // Transforms the custom backend result to an Algolia result.
    public override func map(result: CustomSearchResults) -> SearchResults {
        return SearchResults(nbHits: result.nbHits, hits: result.hits)
    }
}


// TRIAL 2 ------------------------------------------------------------


public protocol Transformer {
    // Transforms the Algolia params to custom backend params.
    func map(query: Query) -> Any
    
    // Transforms the custom backend result to an Algolia result.
    func map(result: Any) -> SearchResults
}

public protocol SearchTransformer: Transformer {
    // Search operation
    func search(_ query: Any, searchResultsHandler: @escaping SearchResultsHandler) -> Operation
}

public class CustomBackend: Searchable {
    let searchTransformer: SearchTransformer
    
    init(searchTransformer: SearchTransformer) {
        self.searchTransformer = searchTransformer
    }
    
    public func search(_ query: Query, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        let params = searchTransformer.map(query: query)
        let operation = searchTransformer.search(params) { (result, error) in
            if let error = error {
                completionHandler(nil, error)
            } else if let result = result {
                let searchResults = self.searchTransformer.map(result: result)
                var content = searchResults.content
                content["hits"] = searchResults.hits
                content["nbHits"] = searchResults.nbHits
                
                completionHandler(content, nil)
            }
        }
        
        return operation
    }
    
    // TODO
    public func searchDisjunctiveFaceting(_ query: Query, disjunctiveFacets: [String], refinements: [String : [String]], requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        return Operation()
    }
    
    // TODO
    public func searchForFacetValues(of facetName: String, matching text: String, query: Query?, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
        return Operation()
    }
}

public class CustomTransformer: SearchTransformer {
    public func search(_ query: Any, searchResultsHandler: @escaping SearchResultsHandler) -> Operation {
        let operation = BlockOperation()
        
        operation.addExecutionBlock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                guard let path = Bundle.main.path(forResource: "mock-custom", ofType: "json") else {
                    print("Invalid filename/path.")
                    return
                }
                do {
                    
                    guard let queryForCustomBackend = query as? CustomSearchQuery, let text = queryForCustomBackend.query else { return }
                    
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    var jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    
                    jsonObj!["hitsCustom"] = (jsonObj!["hitsCustom"] as! [[String: String]]).filter({ item in
                        (item["nameCustom"]?.contains(text))! || (item["descriptionCustom"]?.contains(text))!
                    })
                    
                    searchResultsHandler(jsonObj, nil)
                } catch let error {
                    print(error.localizedDescription)
                }
                
            })
        }
        
        operation.start()
        return operation
    }
    
    // Transforms the Algolia params to custom backend params.
    public func map(query: Query) -> Any {
        let queryText = query.query
        let filters = query.filters
        let facets = query.facets
        return CustomSearchQuery(query: queryText, filters: filters, facets: facets)
    }
    
    // Transforms the custom backend result to an Algolia result.
    public func map(result: Any) -> SearchResults {
        let json = result as! [String: Any]
        
        let nbHitsCustom = json["nbHitsCustom"] as! Int
        let hitsCustom = json["hitsCustom"] as! [[String: Any]]
        let customSearchResults = CustomSearchResults(nbHits: nbHitsCustom, hits: hitsCustom)
        
        
        return SearchResults(nbHits: customSearchResults.nbHits, hits: customSearchResults.hits)
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

// 3- INITIAL TRIAL: DO IT YOURSELF

//public class CustomSearchable:NSObject, Searchable {
//  public func search(_ query: Query, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
//
//    let operation = BlockOperation()
//
//    operation.addExecutionBlock {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//            guard let path = Bundle.main.path(forResource: "mock-custom", ofType: "json") else {
//                print("Invalid filename/path.")
//                return
//            }
//            do {
//              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//              var jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
//
//              let queryForCustomBackend = self.map(query: query) as! CustomSearchQuery
//
//              guard let query = queryForCustomBackend.query else { return }
//
//              jsonObj!["hitsCustom"] = (jsonObj!["hitsCustom"] as! [[String: String]]).filter({ item in
//                (item["nameCustom"]?.contains(query))! || (item["descriptionCustom"]?.contains(query))!
//                })
//
//              let results = self.map(result: jsonObj!)
//              var content = results.content
//              content["hits"] = results.hits
//              content["nbHits"] = results.nbHits
//
//              completionHandler(content, nil)
//            } catch let error {
//              print(error.localizedDescription)
//            }
//
//        })
//    }
//
//    operation.start()
//    return operation
//  }
//
//  public func searchDisjunctiveFaceting(_ query: Query, disjunctiveFacets: [String], refinements: [String : [String]], requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
//    return Operation()
//  }
//
//  public func searchForFacetValues(of facetName: String, matching text: String, query: Query?, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
//    return Operation()
//  }
//}
