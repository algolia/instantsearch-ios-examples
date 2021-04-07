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
  let price: Double?

  var body: some View {
    VStack {
      HStack(alignment: .center, spacing: 20) {
        WebImage(url: imageURL)
          .resizable()
          .indicator(.activity)
          .scaledToFit()
          .clipped()
          .frame(width: 100, height: 100, alignment: .center)
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
          if let priceString = self.priceString {
            HStack(alignment: .bottom, spacing: 2) {
              Text("$")
                .foregroundColor(.orange)
                .font(.system(.footnote))
              Text(priceString)
                .foregroundColor(.black)
                .font(.system(.callout))
            }
          }
        }.multilineTextAlignment(.leading)
      }
      .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 100, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 140, maxHeight: 140, alignment: .leading)
      .padding(.horizontal, 20)
      Divider()
    }
  }
  
  static let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    return formatter
  }()
  
  var priceString: String? {
    price
      .flatMap(NSNumber.init)
      .flatMap(ShopItemRow.priceFormatter.string)
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
    self.price = nil
  }
  
  init(title: String = "",
       subtitle: String = "",
       details: String = "",
       imageURL: URL = URL(string: "")!,
       highlightedTitle: HighlightedString? = nil,
       price: Double? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.details = details
    self.imageURL = imageURL
    self.highlightedTitle = highlightedTitle
    self.price = price
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
    self.price = item.price
  }
  
}

struct ShopItemRow_Previews : PreviewProvider {
    
  static var previews: some View {
    ShopItemRow(
      title: "Samsung - Galaxy S7 32GB - Black Onyx (AT&T)",
      subtitle: "Samsung",
      details: "Enjoy the exceptional display and all-day power of the Samsung Galaxy S7 smartphone. A 12MP rear-facing camera and 5MP front-facing camera capture memories as they happen, and the 5.1-inch display uses dual-pixel technology to display them with superior clarity. The Samsung Galaxy S7 smartphone features durable housing and a water-resistant design.",
      imageURL: URL(string: "https://cdn-demo.algolia.com/bestbuy-0118/4897502_sb.jpg")!,
      highlightedTitle: .init(string: "Samsung - <em>Galaxy</em> S7 32GB - Black Onyx (AT&T)"),
      price: 694.99
  )
  }
}
