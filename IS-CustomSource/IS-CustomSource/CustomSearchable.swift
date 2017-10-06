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

public class DummyOperation: Operation {
  
}

public class CustomSearchable:NSObject, Searchable {
  public func search(_ query: Query, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
    let operation = Operation()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
      if let path = Bundle.main.path(forResource: "mock-light", ofType: "json") {
        do {
          let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
          let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONObject
          completionHandler(jsonObj, nil)
        } catch let error {
          print(error.localizedDescription)
        }
      } else {
        print("Invalid filename/path.")
      }
    })
    return operation
  }
  
  public func searchDisjunctiveFaceting(_ query: Query, disjunctiveFacets: [String], refinements: [String : [String]], requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
    return Operation()
  }
  
  public func searchForFacetValues(of facetName: String, matching text: String, query: Query?, requestOptions: RequestOptions?, completionHandler: @escaping CompletionHandler) -> Operation {
    return Operation()
  }
  
  
}
