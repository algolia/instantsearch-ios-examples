//
//  DynamicFacetsDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 04/03/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class DynamicFacetsDemoViewController: UIViewController {
  
  let dynamicFacetsInteractor = DynamicFacetsInteractor(facetOrder: .test, selections: [:])
  lazy var facetsTableViewController: DynamicFacetsTableViewController = .init()
  let filterState: FilterState = .init()
  
  override func viewDidLoad() {
    addChild(facetsTableViewController)
    facetsTableViewController.didMove(toParent: self)
    super.viewDidLoad()
    facetsTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(facetsTableViewController.view)
    facetsTableViewController.view.pin(to: view)
    facetsTableViewController.selections = [
      "size": ["indigo", "blue"],
      "brand": ["Sony"],
      "color": ["blue"],
    ]
    DynamicFacetsInteractor.FilterStateConnection(interactor: dynamicFacetsInteractor, filterState: filterState).connect()
    DynamicFacetsInteractor.ControllerConnection(interactor: dynamicFacetsInteractor, controller: facetsTableViewController).connect()
  }
  
}


struct FacetOrder: Codable {
  
  static let raw = """
  {
    "facetOrder": [
      {
        "attribute": "size",
        "values": [
          { "value": "red", "count": 15 },
          { "value": "orange", "count": 16 },
          { "value": "yellow", "count": 4 },
          { "value": "green", "count": 7 },
          { "value": "blue", "count": 13 },
          { "value": "indigo", "count": 2 },
          { "value": "violet", "count": 5 }
        ]
      },
      {
        "attribute": "brand",
        "values": [
          { "value": "Uniqlo", "count": 140 },
          { "value": "Apple", "count": 26 },
          { "value": "Sony", "count": 58 },
          { "value": "Dyson", "count": 17 }
        ]
      },
      {
        "attribute": "color",
        "values": [
          { "value": "red", "count": 4 },
          { "value": "orange", "count": 7 },
          { "value": "yellow", "count": 6 },
          { "value": "green", "count": 14 },
          { "value": "blue", "count": 16 },
          { "value": "indigo", "count": 6 },
          { "value": "violet", "count": 2 }
        ]
      }
    ]
  }
  """.data(using: .utf8)!
  
  static let test: Self = try! JSONDecoder().decode(FacetOrder.self, from: FacetOrder.raw)
  
  struct FacetM: Codable {
    let attribute: Attribute
    let facets: [Facet]
    
    enum CodingKeys: String, CodingKey {
      case attribute
      case facets = "values"
    }
  }
  
  let facetOrder: [FacetM]
  
  init(facetOrder: [FacetM] = []) {
    self.facetOrder = facetOrder
  }
  
}

class DynamicFacetsInteractor {
  
  typealias FacetSelections = [Attribute: Set<String>]
  
  var facetOrder: FacetOrder = .test {
    didSet {
      onFacetOrderUpdated.fire(facetOrder)
    }
  }
  var selections: FacetSelections = .init() {
    didSet {
      onSelectionsUpdated.fire(selections)
    }
  }
  
  let onFacetOrderUpdated: Observer<FacetOrder>
  let onSelectionsUpdated: Observer<FacetSelections>
  
  init(facetOrder: FacetOrder, selections: [Attribute: Set<String>]) {
    self.facetOrder = facetOrder
    self.selections = selections
    self.onFacetOrderUpdated = .init()
    self.onSelectionsUpdated = .init()
    onFacetOrderUpdated.fire(facetOrder)
    onSelectionsUpdated.fire(selections)
  }
  
  func isSelected(facetValue: String, for attribute: Attribute) -> Bool {
    return selections[attribute]?.contains(facetValue) ?? false
  }
  
  func toggleSelection(ofFacetValue facetValue: String, for attribute: Attribute) {
    var currentSelections = selections[attribute] ?? []
    if currentSelections.contains(facetValue) {
      currentSelections.remove(facetValue)
    } else {
      currentSelections.insert(facetValue)
    }
    selections[attribute] = currentSelections.isEmpty ? nil : currentSelections
  }
  
}

extension DynamicFacetsInteractor {
  
  struct FilterStateConnection: Connection {
    
    let interactor: DynamicFacetsInteractor
    let filterState: FilterState
    
    init(interactor: DynamicFacetsInteractor, filterState: FilterState) {
      self.interactor = interactor
      self.filterState = filterState
    }
    
    func connect() {
      filterState.onChange.subscribe(with: interactor) { interactor, filters in
        let attributesWithFacets = filters
          .toFilterGroups()
          .flatMap(\.filters)
          .compactMap { $0 as? FacetFilter }
          .filter { !$0.isNegated }
          .map { (attribute: $0.attribute, value: $0.value.description) }
        interactor.selections = Dictionary(grouping: attributesWithFacets, by: \.attribute).mapValues { Set($0.map(\.value)) }
      }
      interactor.onSelectionsUpdated.subscribePast(with: filterState) { (filterState, selections) in
        selections.forEach { attribute, selections in
          for selection in selections {
            filterState[and: "\(attribute)"].toggle(Filter.Facet(attribute: attribute, stringValue: selection))
          }
        }
      }
    }
    
    func disconnect() {
      
    }
    
  }
  
}

extension DynamicFacetsInteractor {
  
  struct ControllerConnection<Controller: DynamicFacetsController>: Connection {
    
    let interactor: DynamicFacetsInteractor
    let controller: Controller
    
    init(interactor: DynamicFacetsInteractor, controller: Controller) {
      self.interactor = interactor
      self.controller = controller
    }
    
    func connect() {
      controller.didSelect = { [weak interactor] attribute, facet in
        guard let interactor = interactor else { return }
        interactor.toggleSelection(ofFacetValue: facet.value, for: attribute)
      }
      interactor.onSelectionsUpdated.subscribePast(with: controller) { (controller, selections) in
        controller.apply(selections)
      }.onQueue(.main)
      interactor.onFacetOrderUpdated.subscribePast(with: controller) { controller, facetOrder in
        controller.apply(facetOrder)
      }.onQueue(.main)
    }
    
    func disconnect() {
      controller.didSelect = nil
      interactor.onSelectionsUpdated.cancelSubscription(for: controller)
      interactor.onFacetOrderUpdated.cancelSubscription(for: controller)
    }
    
  }
  
}

protocol DynamicFacetsController: class {
  
  func apply(_ facetOrder: FacetOrder)
  func apply(_ selections: [Attribute: Set<String>])
  
  var didSelect: ((Attribute, Facet) -> Void)? { get set }
  
}



class DynamicFacetsTableViewController: UITableViewController, DynamicFacetsController {
  
  var facetOrder: FacetOrder
  var selections: [Attribute: Set<String>]
  var didSelect: ((Attribute, Facet) -> Void)?
  
  func apply(_ selections: [Attribute : Set<String>]) {
    self.selections = selections
    tableView.reloadData()
  }
  
  func apply(_ facetOrder: FacetOrder) {
    self.facetOrder = facetOrder
    tableView.reloadData()
  }
  
  init(facetOrder: FacetOrder = .init(), selections: [Attribute: Set<String>] = [:]) {
    self.facetOrder = facetOrder
    self.selections = selections
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    return facetOrder.facetOrder.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return facetOrder.facetOrder[section].facets.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return facetOrder.facetOrder[section].attribute.rawValue
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let fo = facetOrder.facetOrder[indexPath.section]
    let attribute = fo.attribute
    let facet = fo.facets[indexPath.row]
    cell.textLabel?.text = facet.description
    cell.accessoryType = (selections[attribute]?.contains(facet.value) ?? false) ? .checkmark : .none
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let f = facetOrder.facetOrder[indexPath.section]
    didSelect?(f.attribute, f.facets[indexPath.row])
  }
  
}
