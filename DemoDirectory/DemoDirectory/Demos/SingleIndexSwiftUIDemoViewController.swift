//
//  SingleIndexSwiftUIDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 05/02/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import InstantSearch
import SDWebImageSwiftUI

struct ContentView: View {
  
  @ObservedObject var viewModel: AlgoliaViewModel = .init()
    
    var body: some View {
      return VStack(spacing: 10) {
        HStack(alignment: .center, spacing: 5) {
          SearchBar(text: $viewModel.query)
        }.padding(.horizontal, 5)
        Text(viewModel.hitsCountDescription)
          .fontWeight(.medium)
        HitsView<ShopItemRow>(hitsInteractor: viewModel.hitsInteractor)
      }.onAppear {
        self.viewModel.searcher.search()
      }
      .navigationBarTitle("Algolia & SwiftUI")
      .navigationBarItems(trailing: Button(action: {
        
      }) {
        Image(systemName: "line.horizontal.3.decrease.circle").font(.title)
      }
      )
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
      NavigationView {
        ContentView()
      }
    }
}

class AlgoliaViewModel: ObservableObject {

  @Published var hitsCountDescription: String = ""
  @Published var query: String = "" {
    didSet {
      searcher.query = query
      searcher.search()
    }
  }
  
  let searcher: SingleIndexSearcher
  let hitsInteractor: HitsInteractor<SUIShopItem>
  let statsInteractor: StatsInteractor
  var queryInputInteractor: QueryInputInteractor
  
  init() {
    let searcher = SingleIndexSearcher(appID: "latency",
    apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
    indexName: "bestbuy")
    let hitsInteractor = HitsInteractor<SUIShopItem>(infiniteScrolling: .on(withOffset: 20), showItemsOnEmptyQuery: true)
    self.searcher = searcher
    self.queryInputInteractor = .init()
    self.statsInteractor = .init()
    self.hitsInteractor = hitsInteractor
    searcher.indexQueryState.query = Query()
    hitsInteractor.connectSearcher(searcher)
    queryInputInteractor.connectSearcher(searcher)
    statsInteractor.connectSearcher(searcher)
    statsInteractor.onItemChanged.subscribe(with: self) { (viewModel, stats) in
      if let stats = stats {
        viewModel.hitsCountDescription = "\(stats.totalHitsCount) hits in \(stats.processingTimeMS)ms"
      }
    }.onQueue(.main)
  }
  
}

struct SUIShopItem: Codable, Hashable {
  let objectID: String
  let name: String
  let manufacturer: String?
  let shortDescription: String?
  let image: URL?
}

struct ShopItemRow: HitRow {
  
  let title: String
  let subtitle: String
  let details: String
  let imageURL: URL
  let index: Int

  var body: some View {
    HStack(alignment: .center, spacing: 20) {
      Text("\(index)")
        .fontWeight(.light)
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
    }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 100, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 140, maxHeight: 140, alignment: .leading)
  }

  init(title: String) {
    self.title = title
    self.subtitle = ""
    self.details = ""
    self.imageURL = URL(string: "google.com")!
    self.index = 0
  }
  
  init(item: SUIShopItem?, index: Int) {
    self.title = item?.name ?? ""
    self.subtitle = item?.manufacturer ?? ""
    self.details = ""
    self.imageURL = item?.image ?? URL(string: "google.com")!
    self.index = index
  }
}

protocol HitRow: View {
  
  associatedtype Item

  init(item: Item?, index: Int)
}

struct HitsView<Row: HitRow>: View where Row.Item: Codable {
  
  @ObservedObject var hi: HitsInteractor<Row.Item>
        
  var body: some View {
    if #available(iOS 14.0, *) {
      ScrollView(showsIndicators: false) {
        LazyVStack() {
          ForEach(0..<hi.numberOfHits(), id: \.self) { index in
            Row(item: hi.hit(atIndex: index), index: index).onAppear {
              hi.notifyForInfiniteScrolling(rowNumber: index)
            }
          }
        }
      }
    } else {
      List(0..<hi.numberOfHits(), id: \.self) { index in
        Row(item: hi.hit(atIndex: index), index: index).onAppear {
          hi.notifyForInfiniteScrolling(rowNumber: index)
        }
      }
    }
  }
  
  init(hitsInteractor: HitsInteractor<Row.Item>) {
    self.hi = hitsInteractor
    UIScrollView.appearance().keyboardDismissMode = .interactive
  }
  
}

struct SearchBar: View {
  
  @State private var isEditing = false
  @Binding var text: String

  var body: some View {
    HStack {
      ZStack {
        TextField("Search ...", text: $text)
          .padding(7)
          .padding(.horizontal, 25)
          .background(Color(.systemGray5))
          .cornerRadius(8)
          .overlay(
            HStack {
              Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
                .disabled(true)
              if isEditing && !text.isEmpty {
                Button(action: {
                  self.text = ""
                }) {
                  Image(systemName: "multiply.circle.fill")
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
                }
              }
            }
          )
          .padding(.horizontal, 10)
          .onTapGesture {
            self.isEditing = true
          }
      }
      if isEditing {
        Button(action: {
          self.isEditing = false
          self.text = ""
          self.hideKeyboard()
        }) {
          Text("Cancel")
        }
        .padding(.trailing, 10)
        .transition(.move(edge: .trailing))
        .animation(.default)
      }
    }
    .background(Color(.white))
  }
  
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
