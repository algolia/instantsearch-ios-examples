//
//  Stats+SwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25/03/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import SwiftUI
import InstantSearchCore

class StatsObservable: ObservableObject, StatsTextController {
  
  @Published var stats: String = "0 hits in 0ms"
  
  func setItem(_ item: String?) {
    stats = item ?? ""
    objectWillChange.send()
  }
  
}
