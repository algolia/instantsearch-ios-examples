//
//  SearchViewController.swift
//  Icebnb
//
//  Created by Robert Mogos on 05/09/2017.
//  Copyright © 2017 Robert Mogos. All rights reserved.
//

import UIKit
import InstantSearch
import InstantSearchCore
import AlgoliaSearch
import MapKit
import Nuke
import KUIPopOver
import CoreLocation

class SearchViewController: UIViewController, UICollectionViewDelegate, HitsCollectionViewDataSource {
  
  @IBOutlet weak var blurView: UIView!
  @IBOutlet weak var collectionView: HitsCollectionWidget!
  @IBOutlet weak var mapView: MapViewWidget!
  @IBOutlet weak var searchBarView: SearchBarWidget!
  var filterBtn: UIButton!
  var hitsController: HitsController!
  let locationManager = CLLocationManager()
  var lastSearchLocation: CLLocation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Icebnb"
    configureLocationManager()
    configureSearchBar()
    configureInstantSearch()
    configureCollection()
    configureNavbar()
    
    hitsController = HitsController(collection: collectionView)
    collectionView.dataSource = hitsController
    collectionView.delegate = hitsController
    hitsController.collectionDataSource = self
    InstantSearch.shared.searcher.params.aroundRadius = Query.AroundRadius.explicit(UInt(Geo.defaultRadius))
  }
  
  func configureInstantSearch() {
    InstantSearch.shared.registerAllWidgets(in: self.view)
  }
  
  func configureNavbar() {
    filterBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
    filterBtn.setTitle("Filters", for: .normal)
    filterBtn.setTitleColor(.black, for: .normal)
    filterBtn.addTarget(self, action: #selector(filterPressed), for: .touchUpInside)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterBtn)
  }
  
  func configureLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    locationManager.requestWhenInUseAuthorization()
  }
  
  func configureSearchBar() {
    searchBarView.placeholder = "Search items"
    searchBarView.sizeToFit()
    
    searchBarView.barTintColor = ColorConstants.barBackgroundColor
    searchBarView.isTranslucent = true
    searchBarView.layer.cornerRadius = 1.0
    searchBarView.clipsToBounds = true
  }
  
  func configureCollection() {
    collectionView.register(UINib.init(nibName: "PlaceCell", bundle: nil), forCellWithReuseIdentifier: "placeCellIdentifier")
    collectionView.delegate = self
    collectionView.backgroundColor = ColorConstants.tableColor
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = collectionView.bounds
    blurView.backgroundColor = ColorConstants.tableColor
    blurView.insertSubview(blurEffectView, at: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath,
                      containing hit: [String: Any]) -> UICollectionViewCell {
    let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCellIdentifier", for: indexPath) as! PlaceCell
    let place = Place(json: hit)
    collectionViewCell.nameLabel.text = place.name
    collectionViewCell.descriptionLabel.text = (place.price ?? "") + " - " + (place.roomType ?? "" )
    collectionViewCell.imageView.image = nil
    if place.thumbnail != nil, let thumbURL = URL(string: place.thumbnail!) {
      Nuke.loadImage(with: thumbURL, into: collectionViewCell.imageView)
    }
    return collectionViewCell
  }
  
  @objc func filterPressed() {
    let roomFilter: FilterBlock = { ctrl in
      let roomController = TypeFacetViewController(nibName: "TypeFacetViewController", bundle: nil)
      ctrl.navigationController?.pushViewController(roomController, animated: true)
    }
    
    let priceFilter: FilterBlock = { ctrl in
      let rangeController = PriceRangeViewController(nibName: "PriceRangeViewController", bundle: nil)
      ctrl.navigationController?.pushViewController(rangeController, animated: true)
    }
    
    let radiusFilter: FilterBlock = { ctrl in
      let rangeController = RadiusController(nibName: "RadiusController",
                                             bundle: nil,
                                             searcher: InstantSearch.shared.searcher)
      ctrl.navigationController?.pushViewController(rangeController, animated: true)
    }
    
    let controller = FilterViewController(nibName: "FilterViewController",
                                          bundle: nil,
                                          filters: ["Room type" : roomFilter,
                                                    "Price": priceFilter,
                                                    "Radius": radiusFilter])
    controller.showPopover(withNavigationController: filterBtn, sourceRect: filterBtn.bounds)
  }
  
  func showLocationError() {
    
  }
  
  func updateResultsWithLocation() {
    guard let lastSearchLocation = lastSearchLocation else {
      return
    }
    InstantSearch.shared.searcher.params.aroundLatLng = LatLng(lat: lastSearchLocation.coordinate.latitude,
                                                               lng: lastSearchLocation.coordinate.longitude)
    InstantSearch.shared.searcher.search()
  }
}

extension SearchViewController: CLLocationManagerDelegate {
  public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse:
      mapView.showsUserLocation = true
      locationManager.startUpdatingLocation()
      return
    default:
      showLocationError()
    }
  }
  
  public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    showLocationError()
  }
  
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let newLocation = locations.last else {
      return
    }
    
    if lastSearchLocation == nil ||
      newLocation.distance(from: lastSearchLocation!) >= Geo.minimalDistance {
      lastSearchLocation = locations.last
      updateResultsWithLocation()
      return
    }
  }
}
