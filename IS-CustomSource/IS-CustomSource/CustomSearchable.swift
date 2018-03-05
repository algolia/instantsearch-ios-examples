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

public class DummyOperation: Operation {
  
}

public class CustomSearchable:NSObject, Searchable {
  public func search(_ query: Query, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
    
    let operation = BlockOperation()
    weak var weakOp = operation
    operation.addExecutionBlock {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
          if let path = Bundle.main.path(forResource: "mock-light", ofType: "json") {
            do {
              let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
              var jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONObject
              
              guard let query = query.query, !query.isEmpty else {
                if let op = weakOp, !op.isCancelled {
                 completionHandler(jsonObj, nil)
                }
                return
              }
              jsonObj!["hits"] = (jsonObj!["hits"] as! [[String: String]]).filter({ item in
                (item["name"]?.contains(query))! || (item["description"]?.contains(query))!
              })
              if let op = weakOp, !op.isCancelled {
                completionHandler(jsonObj, nil)
              }
            } catch let error {
              print(error.localizedDescription)
            }
          } else {
            print("Invalid filename/path.")
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
  
  
}
