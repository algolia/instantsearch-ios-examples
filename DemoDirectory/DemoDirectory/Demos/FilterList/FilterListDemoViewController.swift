//
//  FilterListDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 26/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class FilterListDemoViewController<F: FilterType & Hashable>: UIViewController {
  
  let controller: FilterListDemoController<F>

  let filterListController: FilterListTableController<F>
  let searchStateViewController: SearchStateViewController
  
  init(items: [F], selectionMode: SelectionMode) {
    filterListController = FilterListTableController(tableView: .init())
    searchStateViewController = SearchStateViewController()
    controller = .init(filters: items,
                       controller: filterListController,
                       selectionMode: selectionMode)
    super.init(nibName: nil, bundle: nil)
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

private extension FilterListDemoViewController {
  
  func setup() {
    searchStateViewController.connectFilterState(controller.filterState)
    searchStateViewController.connectSearcher(controller.searcher)
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
    
    mainStackView.addArrangedSubview(searchStateViewController.view)
    mainStackView.addArrangedSubview(filterListController.tableView)
    
  }
  
}

#if canImport(Combine) && canImport(SwiftUI)
import Combine
import SwiftUI

struct FilterList_Previews : PreviewProvider {
  
  static let facetFiltersObservableController = FilterListObservableController<Filter.Facet>()
  static let facetFilters = ["red", "blue", "green", "yellow", "black"].map {
    Filter.Facet(attribute: "color", stringValue: $0)
  }
  static let facetFiltersDemoController = FilterListDemoController(filters: facetFilters,
                                                                   controller: facetFiltersObservableController,
                                                                   selectionMode: .multiple)
  
  
  
  static let numericFiltersObservableController = FilterListObservableController<Filter.Numeric>()
  static let numericFilters: [Filter.Numeric] = [
    .init(attribute: "price", operator: .lessThan, value: 5),
    .init(attribute: "price", range: 5...10),
    .init(attribute: "price", range: 10...25),
    .init(attribute: "price", range: 25...100),
    .init(attribute: "price", operator: .greaterThan, value: 100)
  ]
  static let numericFiltersDemoController = FilterListDemoController(filters: numericFilters,
                                                                     controller: numericFiltersObservableController,
                                                                     selectionMode: .single)
  
  
  
  static let tagFiltersObservableController = FilterListObservableController<Filter.Tag>()
  static let tagFilters: [Filter.Tag] = [
    "coupon", "free shipping", "free return", "on sale", "no exchange"
  ]
  static let tagFiltersDemoController = FilterListDemoController(filters: tagFilters,
                                                                 controller: tagFiltersObservableController,
                                                                 selectionMode: .multiple)
  
  static func header(text: String) -> some View {
    ZStack {
      Color(.systemGray5)
      Text("Color")
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 5)
    }
  }
  
  static func selectableText(text: String, isSelected: Bool) -> some View {
    HStack {
      Text(text)
      Spacer()
      if isSelected {
        Image(systemName: "checkmark")
          .foregroundColor(.accentColor)
      }
    }
    .contentShape(Rectangle())
  }
  
  static var previews: some View {
    let _ = facetFiltersDemoController
    VStack {
      header(text: "color")
        .frame(maxHeight: 25)
      FilterList(facetFiltersObservableController) { filter, isSelected in
        selectableText(text: filter.value.description, isSelected: isSelected)
          .frame(idealHeight: 44)
          .padding(.horizontal, 5)
      }
      .frame(maxHeight: .infinity)
    }
    FilterList(facetFiltersObservableController) { filter, isSelected in
      HStack {
        Text(filter.value.description)
        Spacer()
        if isSelected {
          Image(systemName: "checkmark")
            .foregroundColor(.accentColor)
        }
      }
      .contentShape(Rectangle())
      .frame(idealHeight: 44)
      .padding(.horizontal, 5)
    }
    let _ = numericFiltersDemoController
    VStack {
      header(text: "price")
        .frame(maxHeight: 25)
      FilterList(numericFiltersObservableController) { filter, isSelected in
        selectableText(text: filter.description, isSelected: isSelected)
          .frame(idealHeight: 44)
          .padding(.horizontal, 5)
      }
      .frame(maxHeight: .infinity)
    }
    let _ = tagFiltersDemoController
    VStack {
      header(text: "price")
        .frame(maxHeight: 25)
      FilterList(tagFiltersObservableController) { filter, isSelected in
        selectableText(text: filter.value.description, isSelected: isSelected)
          .frame(idealHeight: 44)
          .padding(.horizontal, 5)
      }
      .frame(maxHeight: .infinity)
    }
  }
  
}

#endif
