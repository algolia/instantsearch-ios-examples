//
//  ShopItem.swift
//  SearchSuggestions
//
//  Created by Vladislav Fitc on 27/01/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation

struct ShopItem: Codable {
  let name: String
  let description: String
  let brand: String
  let image: URL
}
