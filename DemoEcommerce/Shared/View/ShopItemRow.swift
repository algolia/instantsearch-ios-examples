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
  let imageURL: URL?
  let price: Double?
  let rating: Int?
  let freeShipping: Bool?

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top, spacing: 20) {
        WebImage(url: imageURL)
          .resizable()
          .indicator(.activity)
          .scaledToFit()
          .clipped()
          .frame(width: 100, height: 100, alignment: .top)
          .padding(.top, 10)
        VStack(alignment: .leading, spacing: 10) {
          Text(highlightedString: highlightedTitle!, highlighted: { Text($0).foregroundColor(.accentColor) })
            .font(.title2)
            .lineLimit(2)
          Text(subtitle)
            .font(.subheadline)
            .bold()
          HStack(spacing: 10) {
            if let rating = self.rating {
              HStack(spacing: 4) {
                Image(systemName: "star.fill")
                  .font(.system(.footnote))
                  .padding([.leading, .vertical], 3)
                Text("\(rating)")
                  .padding([.trailing, .vertical], 3)
              }
              .foregroundColor(.orange)
              .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.orange))
            }
            if let freeShipping = self.freeShipping, freeShipping {
              HStack(spacing: 4) {
                Image(systemName: "shippingbox")
                  .font(.system(.footnote))
                  .padding([.leading, .vertical], 3)
                Text("Free shipping")
                  .padding([.trailing, .vertical], 3)
                  .lineLimit(1)
              }
              .foregroundColor(.green)
              .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.green))
            }
          }
          Text(details)
            .font(.body)
            .foregroundColor(.gray)
            .lineLimit(3)
          HStack(spacing: 10) {
            if let priceString = self.priceString {
              HStack(alignment: .bottom, spacing: 2) {
                Text("$")
                  .foregroundColor(.accentColor)
                  .font(.system(.footnote))
                Text(priceString)
                  .font(.system(.headline))
              }
            }
          }
        }.multilineTextAlignment(.leading)
      }
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
    
  init(title: String = "",
       subtitle: String = "",
       details: String = "",
       imageURL: URL? = nil,
       highlightedTitle: HighlightedString? = nil,
       price: Double? = nil,
       rating: Int? = nil,
       freeShipping: Bool? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.details = details
    self.imageURL = imageURL
    self.highlightedTitle = highlightedTitle
    self.price = price
    self.rating = rating
    self.freeShipping = freeShipping
  }
  
  init(isitem: Hit<InstantSearchItem>?) {
    guard let item = isitem?.object else {
      self = .init()
      return
    }
    self.title = item.name
    self.subtitle = item.brand ?? ""
    self.details = item.description ?? ""
    self.imageURL = item.image
    self.highlightedTitle = isitem?.hightlightedString(forKey: "name")
    self.price = item.price
    self.rating = item.rating
    self.freeShipping = item.free_shipping
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
      price: 6940.99,
      rating: 4,
      freeShipping: true
    )
  }
}
