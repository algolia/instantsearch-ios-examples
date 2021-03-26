//
//  Hits+SwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25/03/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import SwiftUI
import InstantSearchCore
import SDWebImageSwiftUI

class HitsObservable<Item: Codable>: ObservableObject, HitsController {
    
  var hitsSource: HitsInteractor<Item>?
  
  func scrollToTop() {
    objectWillChange.send()
  }
  
  func reload() {
    objectWillChange.send()
  }
  
  var hitsCount: Int {
    hitsSource?.numberOfHits() ?? 0
  }
  
  func item(atIndex index: Int) -> Item? {
    return hitsSource?.hit(atIndex: index)
  }
  
  func notify(index: Int) {
    hitsSource?.notifyForInfiniteScrolling(rowNumber: index)
  }
}

struct HitsView<Row: View, Item: Codable, NoResults: View>: View {
  
  @ObservedObject var hitsObservable: HitsObservable<Item>
  var row: (Item?, Int) -> Row
  var noResults: (() -> NoResults)?
  
  init(_ hitsObservable: HitsObservable<Item>,
       @ViewBuilder row: @escaping (Item?, Int) -> Row,
       @ViewBuilder noResults: @escaping () -> NoResults) {
    self.hitsObservable = hitsObservable
    self.row = row
    self.noResults = noResults
    UIScrollView.appearance().keyboardDismissMode = .interactive
  }
  
  private func row(atIndex index: Int) -> some View {
    row(hitsObservable.item(atIndex: index), index).onAppear {
      hitsObservable.notify(index: index)
    }
  }
          
  var body: some View {
    if let noResults = noResults?(), hitsObservable.hitsCount == 0 {
      noResults
    } else {
      if #available(iOS 14.0, *) {
        ScrollView(showsIndicators: false) {
          LazyVStack() {
            ForEach(0..<hitsObservable.hitsCount, id: \.self) { index in
              row(atIndex: index)
              Divider()
            }
          }
        }
      } else {
        List(0..<hitsObservable.hitsCount, id: \.self) { index in
          row(atIndex: index)
          Divider()
        }
      }
    }
  }
    
}

extension HitsView where NoResults == Never {
  
  init(_ hitsObservable: HitsObservable<Item>,
       @ViewBuilder row: @escaping (Item?, Int) -> Row) {
    self.hitsObservable = hitsObservable
    self.row = row
    self.noResults = nil
    UIScrollView.appearance().keyboardDismissMode = .interactive
  }
  
}

struct ShopItemRow: View {
  
  let title: String
  let subtitle: String
  let details: String
  let imageURL: URL

  var body: some View {
    HStack(alignment: .center, spacing: 20) {
      WebImage(url: imageURL)
        .resizable()
        .indicator(.activity)
        .scaledToFit()
        .clipped()
        .frame(width: 100, height: 100, alignment: .leading)
      VStack(alignment: .leading, spacing: 5) {
        Text(title)
          .fontWeight(.heavy)
        Spacer()
          .frame(height: 1, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        Text(subtitle)
          .font(.system(size: 14, weight: .medium, design: .default))
        Text(details)
      }.multilineTextAlignment(.leading)
    }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 100, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 140, maxHeight: 140, alignment: .leading).padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
  }
  
  init(item: SUIShopItem?) {
    self.title = item?.name ?? ""
    self.subtitle = item?.manufacturer ?? ""
    self.details = ""
    self.imageURL = item?.image ?? URL(string: "google.com")!
  }
}
