//
//  MapAnnotation.swift
//  Icebnb
//
//  Created by Robert Mogos on 06/09/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import MapKit
import InstantSearch

class MapAnnotation: NSObject, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  public var title: String?
  public var subtitle: String?
  
  init(_ coordinates: CLLocationCoordinate2D) {
    self.coordinate = coordinates
    super.init()
  }
  
  init (json: JSONObject) {
    guard let lat = json["lat"] as? Double, let lng = json["lng"] as? Double else {
      fatalError("Must contain latitude and longitude")
    }
    self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    self.title = json["name"] as? String
    self.subtitle = (json["price_formatted"] as? String ?? "") + " - " +
                    (json["room_type"] as? String ?? "")
    super.init()
  }
}
