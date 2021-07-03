//
//  CurrentFiltersDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 12/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class CurrentFiltersDemoViewController: UIViewController {

  let filterState: FilterState
  let currentFiltersListConnector: CurrentFiltersConnector
  let currentFiltersListConnector2: CurrentFiltersConnector

  let currentFiltersController: CurrentFilterListTableController
  let currentFiltersController2: SearchTextFieldCurrentFiltersController

  let searchStateViewController: SearchStateViewController

  let tableView: UITableView
  let searchTextField: UISearchTextField

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    searchStateViewController = .init()
    filterState = .init()

    tableView = .init()
    searchTextField = .init()

    currentFiltersController = .init(tableView: tableView)
    currentFiltersController2 = .init(searchTextField: searchTextField)
    
    currentFiltersListConnector = .init(filterState: filterState,
                                        controller: currentFiltersController)

    currentFiltersListConnector2 = .init(filterState: filterState,
                                         groupIDs: [.or(name: "filterFacets", filterType: .facet)],
                                         controller: currentFiltersController2)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupUI()
  }
  
}

private extension CurrentFiltersDemoViewController {

  func setup() {

    searchStateViewController.connectFilterState(filterState)

    let filterFacet1 = Filter.Facet(attribute: "category", value: "table")
    let filterFacet2 = Filter.Facet(attribute: "category", value: "chair")
    let filterFacet3 = Filter.Facet(attribute: "category", value: "clothes")
    let filterFacet4 = Filter.Facet(attribute: "category", value: "kitchen")

    filterState[or: "filterFacets"].add(filterFacet1,
                                        filterFacet2,
                                        filterFacet3,
                                        filterFacet4)
    
    let filterNumeric1 = Filter.Numeric(attribute: "price", operator: .greaterThan, value: 10)
    let filterNumeric2 = Filter.Numeric(attribute: "price", operator: .lessThan, value: 20)

    filterState[and: "filterNumerics"].add(filterNumeric1,
                                           filterNumeric2)

    filterState.notifyChange()
  }

  func setupUI() {

    view.backgroundColor = .white

    let mainStackView = UIStackView()
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.axis = .vertical
    mainStackView.spacing = .px16

    view.addSubview(mainStackView)

    mainStackView.pin(to: view.safeAreaLayoutGuide)

    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    tableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    searchTextField.translatesAutoresizingMaskIntoConstraints = false
    let searchTextFieldContainer = UIView()
    searchTextFieldContainer.heightAnchor.constraint(equalToConstant: 54).isActive = true
    searchTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
    searchTextFieldContainer.addSubview(searchTextField)
    searchTextField.pin(to: searchTextFieldContainer, insets: UIEdgeInsets(top: 5, left: 5, bottom: -5, right: -5))

    mainStackView.addArrangedSubview(searchStateViewController.view)
    mainStackView.addArrangedSubview(searchTextFieldContainer)
    mainStackView.addArrangedSubview(tableView)
    
  }

}

import SwiftUI

struct CurrentFiltersDemoSwiftUI: PreviewProvider {
  
  struct ContentView: View {
    
    @ObservedObject var currentFiltersController: CurrentFiltersObservableController
    
    var body: some View {
      VStack {
        Text("Filters")
          .font(.title)
        let filtersPerGroup = Dictionary(grouping: currentFiltersController.filters) { el in
          el.id
        }
        .mapValues { $0.map(\.filter) }
        .map { $0 }
        ForEach(filtersPerGroup, id: \.key) { (group, filters) in
          HStack {
            Text(group.description)
              .bold()
              .padding(.leading, 5)
            Spacer()
          }
          .padding(.vertical, 5)
          .background(Color(.systemGray5))
          ForEach(filters, id: \.self) { filter in
            HStack {
              Text(filter.description)
                .padding(.leading, 5)
              Spacer()
            }
          }
        }
        Spacer()
      }
    }
    
  }
  
  static var previews: some View {
    ContentView(currentFiltersController: .init(filters: [
      .init(filter: .facet(.init(attribute: "brand", stringValue: "sony")), id: .and(name: "groupA")),
      .init(filter: .numeric(.init(attribute: "price", range: 50...100)), id: .and(name: "groupA")),
      .init(filter: .tag("Free delivery"), id: .and(name: "groupA")),
      .init(filter: .numeric(.init(attribute: "salesRank", operator: .lessThan, value: 100)), id: .and(name: "groupB")),
      .init(filter: .tag("On Sale"), id: .and(name: "groupB"))
    ]))
  }
  
}
