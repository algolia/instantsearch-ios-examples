//
//  RatingController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 21/04/2021.
//

import Foundation
import InstantSearch

class RatingController: ObservableObject, FacetListController {
  
  @Published var maxRating: Int = 5
  @Published var selectedRating: Int?
  @Published var itemsCountPerRating: [Int: Int] = [:]
  
  var onClick: ((Facet) -> Void)?
  var didChangeSelected: ((Int?) -> Void)?
    
  func select(minRating: Int) {
    if minRating == selectedRating {
      selectedRating = nil
    } else {
      selectedRating = minRating
    }
    didChangeSelected?(selectedRating)
  }
  
  func setSelectableItems(selectableItems: [SelectableItem<Facet>]) {
    let itemsCountList = (1..<maxRating)
      .map { (rating) -> (Int, Int) in
        let count = selectableItems
          .map(\.item)
          .filter { Int($0.value).flatMap { $0 >= rating } ?? false }
          .map(\.count)
          .reduce(0, +)
        return (rating, count)
      }
    itemsCountPerRating = Dictionary(uniqueKeysWithValues: itemsCountList)
    selectedRating = selectableItems
      .filter { (_, isSelected) in isSelected }
      .compactMap { (item, _) in Int(item.value) }
      .min()
  }
  
  func reload() {
    objectWillChange.send()
  }
    
}
