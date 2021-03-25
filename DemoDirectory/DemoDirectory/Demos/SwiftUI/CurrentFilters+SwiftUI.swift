//
//  CurrentFilters+SwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25/03/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import SwiftUI
import InstantSearchCore

class CurrentFiltersObservable: ObservableObject, CurrentFiltersController {
  
  @Published var isEmpty: Bool = true
  
  func setItems(_ items: [FilterAndID]) {
    isEmpty = items.isEmpty
  }
  
  var onRemoveItem: ((FilterAndID) -> Void)?
  
  func reload() {
    objectWillChange.send()
  }
  
}
