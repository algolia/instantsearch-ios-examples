//
//  Place.swift
//  Icebnb
//
//  Created by Robert Mogos on 05/09/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import Foundation
import AlgoliaSearch
import InstantSearchCore

struct Place {
  private var json: JSONObject
  
  init(json: JSONObject) {
    self.json = json
  }
  
  var name: String? {
    return json["name"] as? String
  }
  
  var location: String? {
    return json["smart_location"] as? String
  }
  
  var price: String? {
    return json["price_formatted"] as? String
  }
  
  var thumbnail: String? {
    return json["thumbnail_url"] as? String
  }
  
  var roomType: String? {
    return json["room_type"] as? String
  }
}
