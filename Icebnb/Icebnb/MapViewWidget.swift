//
//  MapViewWidget.swift
//  Icebnb
//
//  Created by Robert Mogos on 06/09/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import MapKit
import InstantSearch
import InstantSearchCore
import AlgoliaSearch

class MapViewWidget: MKMapView, AlgoliaWidget, ResultingDelegate {
  
  func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
    
    let searchParams = userInfo["params"] as? SearchParameters
    if searchParams == nil || searchParams?.page == 0 {
      let annotations = self.annotations
      removeAnnotations(annotations)
    }
    guard let results = results else {
      return
    }
    results.hits.forEach({ [weak self] hit in
      let annotation = MapAnnotation(json: hit)
      self?.addAnnotation(annotation)
    })
    
    showAnnotations(self.annotations, animated: true)
  }
}
