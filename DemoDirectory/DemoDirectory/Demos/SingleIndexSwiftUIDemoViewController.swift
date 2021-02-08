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
        SearchBar(text: viewModel.queryBinding)
        Text(viewModel.hitsCountDescription)
          .fontWeight(.medium)
        HitsView<ShopItemRow>(hitsCount: $viewModel.hitsCount,
                 lastAppear: viewModel.lastRowIndexBinding,
                 fetcher: viewModel.hitsInteractor.hit(atIndex:))
      }.onAppear {
        self.viewModel.searcher.search()
      }
    }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
       ContentView()
    }
}

class AlgoliaViewModel: ObservableObject {

  @Published var hitsCountDescription: String = ""
  @Published var hitsCount: Int = 0
  var hitFetcher: ((Int) -> SUIShopItem?)

  let queryBinding: Binding<String>
  let lastRowIndexBinding: Binding<Int>
  
  let searcher: SingleIndexSearcher
  let hitsInteractor: HitsInteractor<SUIShopItem>
  let statsInteractor: StatsInteractor
    
  init() {
    let searcher = SingleIndexSearcher(appID: "latency",
    apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
    indexName: "bestbuy")
    let hitsInteractor = HitsInteractor<SUIShopItem>(infiniteScrolling: .on(withOffset: 20), showItemsOnEmptyQuery: true)
    hitsInteractor.connectSearcher(searcher)
    self.searcher = searcher
    self.statsInteractor = .init()
    self.hitsInteractor = hitsInteractor
    searcher.indexQueryState.query = Query()
    hitFetcher = hitsInteractor.hit(atIndex:)
    queryBinding = .init(
      get: {
        searcher.query ?? ""
      },
      set: {
        searcher.query = $0
        searcher.search()
      }
    )
    lastRowIndexBinding = .init(
      get: { 0 },
      set: {
        hitsInteractor.notifyForInfiniteScrolling(rowNumber: $0)
      }
    )
    searcher.onResults.subscribe(with: self) { (viewModel, response) in
      print("Received result for query \(response.query), page \(response.page), hits: \(response.hits.count)")
    }
    hitsInteractor.onResultsUpdated.subscribe(with: self) { (viewModel, results) in
      viewModel.hitsCount = viewModel.hitsInteractor.numberOfHits()
    }.onQueue(.main)
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
    }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 100, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 140, maxHeight: 140, alignment: .leading)
  }

  init(title: String) {
    self.title = title
    self.subtitle = ""
    self.details = ""
    self.imageURL = URL(string: "google.com")!
  }
  
  init(item: SUIShopItem?) {
    self.title = item?.name ?? ""
    self.subtitle = item?.manufacturer ?? ""
    self.details = ""
    self.imageURL = item?.image ?? URL(string: "google.com")!
  }
}

protocol HitRow: View {
  
  associatedtype Item

  init(item: Item?)
}

struct HitsView<Row: HitRow>: View {
  
  @Binding var hitsCount: Int
  @Binding var lastAppear: Int
  var fetcher: (Int) -> Row.Item?
  
  var body: some View {
    List(0..<hitsCount, id: \.self) { index in
      Row(item: fetcher(index)).onAppear {
       lastAppear = index
      }
    }
  }
  
}

struct SearchBar: View {
  
  @State private var isEditing = false
  @Binding var text: String

  var body: some View {
    HStack {
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

                    if isEditing {
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
         if isEditing {
           Button(action: {
               self.isEditing = false
               self.text = ""
           }) {
               Text("Cancel")
           }
           .padding(.trailing, 10)
           .transition(.move(edge: .trailing))
           .animation(.default)
        }
    }
    .background(Color(.white))
    .padding(.top, 20)

  }
  
}
