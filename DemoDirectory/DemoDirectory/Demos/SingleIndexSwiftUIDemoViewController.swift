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

struct ContentView: View {
  
  @ObservedObject var viewModel: AlgoliaViewModel = .init()
    
    var body: some View {
      return VStack {
        SearchBar(text: viewModel.queryBinding)
        Text("Hello world!")
          .fontWeight(.medium)
        HitsView(hits: $viewModel.hits, lastAppearedRowIndex: viewModel.lastRowIndexBinding)
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
  
  @Published var hits: [HitItem] = []
  @Published var hitsCountDescription: String = ""

  let queryBinding: Binding<String>
  let lastRowIndexBinding: Binding<Int>
  
  let searcher: SingleIndexSearcher
  let hitsInteractor: HitsInteractor<HitItem>
  let statsInteractor: StatsInteractor
    
  init() {
    let searcher = SingleIndexSearcher(appID: "latency",
    apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
    indexName: "bestbuy")
    let hitsInteractor = HitsInteractor<HitItem>(infiniteScrolling: .on(withOffset: 20), showItemsOnEmptyQuery: false)
    hitsInteractor.connectSearcher(searcher)
    self.searcher = searcher
    self.statsInteractor = .init()
    self.hitsInteractor = hitsInteractor
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
        _ = hitsInteractor.hit(atIndex: $0)
      }
    )
    hitsInteractor.onResultsUpdated.subscribe(with: self) { (viewModel, results) in
      viewModel.hits = viewModel.hitsInteractor.getCurrentHits()
    }.onQueue(.main)
    statsInteractor.connectSearcher(searcher)
    statsInteractor.onItemChanged.subscribe(with: self) { (viewModel, stats) in
      if let stats = stats {
        viewModel.hitsCountDescription = "\(stats.totalHitsCount) hits"
      }
    }.onQueue(.main)
  }
  
}

struct HitItem: Codable, Hashable {
  let objectID: String
  let name: String
}

struct HitRow: View {
    let text: String

    var body: some View {
      Text(text)
    }

    init(bestBuyItem: HitItem) {
      self.text = bestBuyItem.name
    }
}

struct HitsView: View {
  
  @Binding var hits: [HitItem]
  @Binding var lastAppearedRowIndex: Int
  
  var body: some View {
    List(hits, id: \.objectID) { hit in
        HitRow(bestBuyItem: hit).onAppear {
          if let index = self.hits.firstIndex(of: hit) {
            print(index)
            self.lastAppearedRowIndex = index
          }
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
