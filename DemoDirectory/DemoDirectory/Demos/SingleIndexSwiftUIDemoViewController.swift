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

struct FacetListView: View {

  @Binding var facets: [(Facet, Bool)]
  var select: (Facet) -> Void

  var body: some View {
    if #available(iOS 14.0, *) {
      ScrollView(showsIndicators: true) {
        LazyVStack() {
          ForEach(facets, id: \.0) { (facet, isSelected) in
            FacetRow(facet: facet, isSelected: isSelected).onTapGesture {
              select(facet)
            }
            Divider()
          }
        }
      }
    } else {
      List(facets, id: \.0) { (facet, isSelected) in
        Text(facet.description)
      }
    }
  }

}

class FacetListObservable: ObservableObject, FacetListController {
  
  @Published var facets: [(Facet, Bool)] = []
  
  var onClick: ((Facet) -> Void)?
        
  func setSelectableItems(selectableItems: [SelectableItem<Facet>]) {
    DispatchQueue.main.async {
      self.facets = selectableItems
    }
  }
  
  func reload() {
    objectWillChange.send()
  }

}

struct ContentView: View {
  
  @State private var showModal = false
  @ObservedObject var viewModel: AlgoliaViewModel = .init()
  @ObservedObject var statsObservable: StatsObservable = .init()
  @ObservedObject var hitsInteractor: HitsInteractor<SUIShopItem> = .init()
  @ObservedObject var facetListObservable: FacetListObservable = .init()

    var body: some View {
      return VStack(spacing: 10) {
        HStack(alignment: .center, spacing: 5) {
          SearchBar(text: $viewModel.query)
        }.padding(.horizontal, 5)
        Text(statsObservable.stats)
          .fontWeight(.medium)
        HitsView(hitsInteractor: hitsInteractor) { (item, _) in
          ShopItemRow(item: item)
        } noResults: {
          Text("No Results")
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }

      }.onAppear {
        hitsInteractor.connectSearcher(viewModel.searcher)
        viewModel.statsInteractor.connectController(statsObservable)
        viewModel.facetListInteractor.connectController(facetListObservable, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
        viewModel.searcher.search()
      }
      .navigationBarTitle("Algolia & SwiftUI")
      .navigationBarItems(trailing:
                            Button(action: { withAnimation { showModal.toggle() } },
                                   label: {
                                    Image(systemName: "line.horizontal.3.decrease.circle")
                                      .font(.title)
                                   }).sheet(isPresented: $showModal, content: {
                                    NavigationView {
                                      VStack {
                                        Text(statsObservable.stats)
                                          .fontWeight(.medium)
                                        FacetListView(facets: $facetListObservable.facets,
                                                      select: facetListObservable.onClick!)
                                      }
                                      .navigationBarTitle("Manufacturer")
                                    }
                                   })
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

class StatsObservable: ObservableObject, StatsTextController {
  @Published
  var stats: String = "observable"
  
  func setItem(_ item: String?) {
    stats = item ?? ""
    objectWillChange.send()
  }
  
}

class AlgoliaViewModel: ObservableObject {

  @Published var query: String = "" {
    didSet {
      searcher.query = query
      searcher.search()
    }
  }
  
  let searcher: SingleIndexSearcher
  let statsInteractor: StatsInteractor
  let facetListInteractor: FacetListInteractor
  let filterState: FilterState
  
  init() {
    let searcher = SingleIndexSearcher(appID: "latency",
    apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
    indexName: "bestbuy")
    self.searcher = searcher
    self.statsInteractor = .init()
    self.facetListInteractor = .init()
    self.filterState = .init()
    searcher.connectFilterState(filterState)
    facetListInteractor.connectSearcher(searcher, with: "manufacturer")
    facetListInteractor.connectFilterState(filterState, with: "manufacturer", operator: .or)
    statsInteractor.connectSearcher(searcher)
  }
    
}

struct SUIShopItem: Codable, Hashable {
  let objectID: String
  let name: String
  let manufacturer: String?
  let shortDescription: String?
  let image: URL?
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

struct HitsView<Row: View, Item: Codable, NoResults: View>: View {
  
  @ObservedObject var hitsInteractor: HitsInteractor<Item>
  var content: (Item?, Int) -> Row
  var noResults: () -> NoResults
  
  init(hitsInteractor: HitsInteractor<Item>, @ViewBuilder content: @escaping (Item?, Int) -> Row, @ViewBuilder noResults: @escaping () -> NoResults) {
    self.hitsInteractor = hitsInteractor
    self.content = content
    self.noResults = noResults
    UIScrollView.appearance().keyboardDismissMode = .interactive
  }
        
  var body: some View {
    if #available(iOS 14.0, *) {
      if hitsInteractor.numberOfHits() == 0 {
        noResults()
      } else {
        ScrollView(showsIndicators: false) {
          LazyVStack() {
            ForEach(0..<hitsInteractor.numberOfHits(), id: \.self) { index in
              content(hitsInteractor.hit(atIndex: index), index).onAppear {
                hitsInteractor.notifyForInfiniteScrolling(rowNumber: index)
              }
              Divider()
            }
          }
        }
      }
    } else {
      List(0..<hitsInteractor.numberOfHits(), id: \.self) { index in
        content(hitsInteractor.hit(atIndex: index), index).onAppear {
          hitsInteractor.notifyForInfiniteScrolling(rowNumber: index)
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

struct FacetRow: View {
  
  var facet: Facet
  var isSelected: Bool
  
  var body: some View {
    HStack {
      Text(facet.description)
        .font(.footnote)
        .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
      Spacer()
      if isSelected {
        Image(systemName: "checkmark")
          .font(.footnote)
          .frame(minWidth: 44, alignment: .trailing)
      }
    }
    .padding(.horizontal, 20)
  }
}
