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

// POC 1 Implem

public class CustomSearchableImplementation: SearchTransformer<CustomSearchParameters, CustomSearchResults> {
    public override func search(_ query: CustomSearchParameters, searchResultsHandler: @escaping SearchResultsHandler) -> Operation {
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
                    let customSearchResults = CustomSearchResults(nbHitsCustom: nbHitsCustom, hitsCustom: hitsCustom)
                    
                    // IMPORTANT: Need to call the searchResultHandler when done, this is the responsibility of the 3rd party dev
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
    public override func map(query: Query) -> CustomSearchParameters {
        let queryText = query.query
        let filters = query.filters
        let facets = query.facets
        
        return CustomSearchParameters(query: queryText, filters: filters, facets: facets)
    }
    
    // Transforms the custom backend result to an Algolia result.
    public override func map(result: CustomSearchResults) -> SearchResults {
        let nbHitsCustom = result.nbHitsCustom
        let hitsCustom = result.hitsCustom
        
        return SearchResults(nbHits: nbHitsCustom, hits: hitsCustom)
    }
}

// POC 2 Implem

public class CustomSearchTransformerImplementation: SearchTransformable {
    public func search(_ query: Any, searchResultsHandler: @escaping SearchAnyResultsHandler) -> Operation {
        let operation = BlockOperation()
        
        operation.addExecutionBlock {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                guard let path = Bundle.main.path(forResource: "mock-custom", ofType: "json") else {
                    print("Invalid filename/path.")
                    return
                }
                do {
                    // IMPORTANT: With this method, we have to do some type casting for query to CustomSearchParameters. This is not the case in POC 1.
                    guard let queryForCustomBackend = query as? CustomSearchParameters, let text = queryForCustomBackend.query else { return }
                    
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                    var jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    jsonObj!["hitsCustom"] = (jsonObj!["hitsCustom"] as! [[String: String]]).filter({ item in
                        (item["nameCustom"]?.contains(text))! || (item["descriptionCustom"]?.contains(text))!
                    })
                    
                    // IMPORTANT: Need to call the searchResultHandler when done, this is the responsibility of the 3rd party dev
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
        return CustomSearchParameters(query: queryText, filters: filters, facets: facets)
    }
    
    // Transforms the custom backend result to an Algolia result.
    public func map(result: Any) -> SearchResults {
        let json = result as! [String: Any]
        
        let nbHitsCustom = json["nbHitsCustom"] as! Int
        let hitsCustom = json["hitsCustom"] as! [[String: Any]]
        let customSearchResults = CustomSearchResults(nbHitsCustom: nbHitsCustom, hitsCustom: hitsCustom)
        
        
        return SearchResults(nbHits: customSearchResults.nbHitsCustom, hits: customSearchResults.hitsCustom)
    }
}

// 3- INITIAL TRIAL: DO IT YOURSELF STYLE

//public class CustomSearchableDIY:NSObject, Searchable {
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
//              let queryForCustomBackend = self.map(query: query) as! CustomSearchParameters
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

