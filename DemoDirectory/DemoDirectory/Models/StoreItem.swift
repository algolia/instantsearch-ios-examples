//
//  StoreItem.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 21/03/2022.
//  Copyright © 2022 Algolia. All rights reserved.
//

import Foundation

struct StoreItem: Codable {
  
  let name: String
  let brand: String
  let productType: String
  let images: [URL]
  
  enum CodingKeys: String, CodingKey {
    case name
    case brand
    case productType = "product_type"
    case images = "image_urls"
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.brand = try container.decode(String.self, forKey: .brand)
    self.productType = try container.decode(String.self, forKey: .productType)
    let rawImages = try container.decode([String].self, forKey: .images)
    self.images = rawImages.compactMap(URL.init)
  }
  
}
