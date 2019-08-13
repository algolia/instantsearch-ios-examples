//
//  DemoHelper.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 06/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

extension Client {
  static let demo = Client(appID: "latency", apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db")
}

extension Index {
  
  static func demo(withName demoIndexName: String) -> Index {
    return Client.demo.index(withName: demoIndexName)
  }
  
}

struct DemoHelper {
  public static let appID = "latency"
  public static let apiKey = "1f6fd3a6fb973cb08419fe7d288fa4db"
}

extension IndexPath {
  static let zero = IndexPath(row: 0, section: 0)
}
