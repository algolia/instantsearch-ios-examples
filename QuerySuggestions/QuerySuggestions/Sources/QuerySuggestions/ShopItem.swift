//
//  ShopItem.swift
//  QuerySuggestions
//
//  Created by Vladislav Fitc on 27/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

public struct ShopItem: Codable {
  public let name: String
  public let description: String
  public let brand: String
  public let image: URL
}
