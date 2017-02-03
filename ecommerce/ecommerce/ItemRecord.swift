//
//  ItemRecord.swift
//  ecommerce
//
//  Created by Guy Daher on 03/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import AlgoliaSearch
import InstantSearchCore
import Foundation

struct ItemRecord {
    private var json: JSONObject
    private let MAX_BEST_SELLING_RANK = 32691;
    
    init(json: JSONObject) {
        self.json = json
    }
    
    var name: String? {
        return json["name"] as? String
    }
    
    var manufacturer: String? {
        return json["manufacturer"] as? String
    }
    
    var category: String? {
        return json["category"] as? String
    }
    
    var price: Double? {
        return json["salePrice"] as? Double
    }
    
    var stars: Double? {
        guard let bestSellingRank = json["bestSellingRank"] as? Int else { return nil }
        
        switch bestSellingRank {
        case 1...49: return 5
        case 50...499: return 4.5
        case 500...2499: return 4
        case 2500...5000: return 3.5
        case 5001...9999: return 3
        case 10000...14999: return 2.5
        case 15000...19999: return 2
        case 20000...24999: return 1.5
        case 25000...29000: return 1
        case 30000...MAX_BEST_SELLING_RANK: return 0.5
        default: return 0
        }
    }
    
    var customerReviewCount: Int? {
        return json["customerReviewCount"] as? Int
    }
    
    var imageUrl: URL? {
        guard let urlString = json["image"] as? String else { return nil }
        return URL(string: urlString)
    }
    
    var title_highlighted: String? {
        return SearchResults.highlightResult(hit: json, path: "name")?.value
    }
}

