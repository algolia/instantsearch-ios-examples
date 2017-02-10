//
//  FacetRecord.swift
//  ecommerce
//
//  Created by Guy Daher on 09/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import AlgoliaSearch

public class FacetRecord: NSObject {
    private var _value: String?
    private var _count: Int?
//    var highlighted: String
    
    private var json: JSONObject?
    
    init(json: JSONObject) {
        self.json = json
    }
    
    init(value: String, count: Int) {
        _value = value
        _count = count
    }
    
    public var value: String? {
        return _value ?? json?["value"] as? String
    }
    
    public var count: Int? {
        return _count ?? json?["count"] as? Int
    }
    
    public var highlighted: String? {
        return json?["highlighted"] as? String
    }
    
    
//    public var value_highlighted: String? {
//        return SearchResults.highlightResult(hit: json, path: "highlighted")?.value
//    }
}
