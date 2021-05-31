//
//  InstantSearchItem.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 10/04/2021.
//

import Foundation

struct InstantSearchItem: Codable, Hashable {
  let objectID: String
  let name: String
  let brand: String?
  let description: String?
  let image: URL?
  let price: Double?
  let free_shipping: Bool?
  let rating: Int?
  let categories: [String]?
  let hierarchicalCategories: [String: String]?
}
