//
//  ShopItemRow.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 03/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import SwiftUI
import InstantSearch
import SDWebImageSwiftUI

struct ShopItemRow: View {
  
  let title: String
  let highlightedTitle: HighlightedString?
  let subtitle: String
  let details: String
  let imageURL: URL

  var body: some View {
    VStack {
      HStack(alignment: .center, spacing: 20) {
        WebImage(url: imageURL)
          .resizable()
          .indicator(.activity)
          .scaledToFit()
          .clipped()
          .frame(width: 100, height: 100, alignment: .topLeading)
        VStack(alignment: .leading, spacing: 5) {
          Text(highlightedString: highlightedTitle!, highlighted: { Text($0).foregroundColor(.blue) })
            .font(.system(.headline))
          Spacer()
            .frame(height: 1, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          Text(subtitle)
            .font(.system(size: 14, weight: .medium, design: .default))
          Text(details)
            .font(.system(.caption))
            .foregroundColor(.gray)
        }.multilineTextAlignment(.leading)
      }
      .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 100, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 140, maxHeight: 140, alignment: .leading)
      .padding(.horizontal, 20)
      Divider()
    }
  }
  
  init(item: Hit<SUIShopItem>?) {
    guard let item = item else {
      self = .init()
      return
    }
    self.title = item.object.name
    self.subtitle = item.object.manufacturer ?? ""
    self.details = ""
    self.imageURL = item.object.image ?? URL(string: "google.com")!
    self.highlightedTitle = item.hightlightedString(forKey: "name")
  }
  
  init() {
    self.title = ""
    self.subtitle = ""
    self.details = ""
    self.imageURL = URL(string: "")!
    self.highlightedTitle = .init(string: "")
  }
  
  init(isitem: Hit<InstantSearchItem>?) {
    guard let item = isitem?.object else {
      self = .init()
      return
    }
    self.title = item.name
    self.subtitle = item.brand ?? ""
    self.details = item.description ?? ""
    self.imageURL = item.image ?? URL(string: "google.com")!
    self.highlightedTitle = isitem?.hightlightedString(forKey: "name")
  }
  
}
