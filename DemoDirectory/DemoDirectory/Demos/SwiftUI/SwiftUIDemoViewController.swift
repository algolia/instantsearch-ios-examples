//
//  SwiftUIDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25/03/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import SwiftUI
import SDWebImageSwiftUI

class SwiftUIDemoViewController: UIHostingController<ContentView> {
  
  let viewModel = AlgoliaViewModel.test
  
  init() {
    let contentView = ContentView()
    super.init(rootView: contentView)
    viewModel.setup(contentView)
    viewModel.searcher.search()
    UIScrollView.appearance().keyboardDismissMode = .interactive
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

struct ContentView: View {
  
  @ObservedObject var statsObservable: StatsObservableController
  @ObservedObject var hitsObservable: HitsObservableController<Hit<SUIShopItem>>
  @ObservedObject var facetStorage: FacetListObservableController
  @ObservedObject var currentFiltersObservable: CurrentFiltersObservableController
  @ObservedObject var queryInputObservable: QueryInputObservableController
  @ObservedObject var filterClearObservable: FilterClearObservable

  @State private var showFacets = false
  
  init() {
    statsObservable = .init()
    hitsObservable = .init()
    facetStorage = .init()
    currentFiltersObservable = .init()
    queryInputObservable = .init()
    filterClearObservable = .init()
  }
  
  var body: some View {
    return VStack(spacing: 7) {
      SearchBar(text: $queryInputObservable.query)
      Text(statsObservable.stats)
        .fontWeight(.medium)
      HitsList(hitsObservable) { (hit, _) in
        ShopItemRow(item: hit)
      } noResults: {
        Text("No Results")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .navigationBarTitle("Algolia & SwiftUI")
    .navigationBarItems(trailing: facetsButton())
  }
  
  private func facetsButton() -> some View {
    Button(action: { withAnimation { showFacets.toggle() } },
           label: {
            let imageName = currentFiltersObservable.isEmpty ? "line.horizontal.3.decrease.circle" : "line.horizontal.3.decrease.circle.fill"
            Image(systemName: imageName)
              .font(.title)
           }).sheet(isPresented: $showFacets,
                    content: facetsView)

  }
  
  private func facetsView() -> some View {
    NavigationView {
      if #available(iOS 14.0, *) {
        VStack {
          FacetList(facetStorage) { facet, isSelected in
            VStack {
              FacetRow(facet: facet, isSelected: isSelected)
              Divider()
            }
            .padding(.vertical, 7)
            .background(Color(.systemBackground))
          }
        }
        .navigationBarTitle("Manufacturer")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
              Spacer()
            }
            ToolbarItem(placement: .bottomBar) {
              Text(statsObservable.stats)
            }
            ToolbarItem(placement: .bottomBar) {
              Spacer()
            }
            ToolbarItem(placement: .bottomBar) {
              Button(action: filterClearObservable.clear,
                     label: { Image(systemName: "trash") }
              ).disabled(currentFiltersObservable.isEmpty)
            }
        }
      } else {
        VStack {
          Text(statsObservable.stats)
            .fontWeight(.medium)
          FacetList(facetStorage) { facet, isSelected in
            VStack {
              FacetRow(facet: facet, isSelected: isSelected)
                .background(Color(.green))
              Divider()
            }
            .padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .background(Color(.systemBackground))
          }
        }
        .navigationBarTitle("Manufacturer")
      }
    }
  }
  
}

struct ContentView_Previews : PreviewProvider {
  
  static let viewModel = AlgoliaViewModel.test
  
  static var previews: some View {
    let contentView = ContentView()
    let _ = viewModel.setup(contentView)
    NavigationView {
      contentView
    }.onAppear {
      viewModel.searcher.search()
    }
  }
}

class AlgoliaViewModel {
  
  let appID: ApplicationID
  let apiKey: APIKey
  let indexName: IndexName
  let facetAttribute: Attribute
  
  let searcher: SingleIndexSearcher
  let queryInputInteractor: QueryInputInteractor
  let hitsInteractor: HitsInteractor<Hit<SUIShopItem>>
  let statsInteractor: StatsInteractor
  let facetListInteractor: FacetListInteractor
  let currentFiltersInteractor: CurrentFiltersInteractor
  let filterState: FilterState
  let filterClearInteractor: FilterClearInteractor
    
  init(appID: ApplicationID,
       apiKey: APIKey,
       indexName: IndexName,
       facetAttribute: Attribute) {
    self.appID = appID
    self.apiKey = apiKey
    self.indexName = indexName
    self.facetAttribute = facetAttribute
    let searcher = SingleIndexSearcher(appID: appID,
                                       apiKey: apiKey,
                                       indexName: indexName)
    self.searcher = searcher
    self.hitsInteractor = .init()
    self.statsInteractor = .init()
    self.facetListInteractor = .init()
    self.filterState = .init()
    self.currentFiltersInteractor = .init()
    self.queryInputInteractor = .init()
    self.filterClearInteractor = .init()
    setupConnections()
  }
  
  fileprivate func setupConnections() {
    searcher.connectFilterState(filterState)
    hitsInteractor.connectSearcher(searcher)
    facetListInteractor.connectSearcher(searcher, with: facetAttribute)
    facetListInteractor.connectFilterState(filterState, with: facetAttribute, operator: .or)
    statsInteractor.connectSearcher(searcher)
    currentFiltersInteractor.connectFilterState(filterState)
    queryInputInteractor.connectSearcher(searcher)
    filterClearInteractor.connectFilterState(filterState,
                                             filterGroupIDs: [.or(name: facetAttribute.rawValue, filterType: .facet)],
                                             clearMode: .specified)
  }
  
  func setup(_ contentView: ContentView) {
    hitsInteractor.connectController(contentView.hitsObservable)
    statsInteractor.connectController(contentView.statsObservable)
    facetListInteractor.connectController(contentView.facetStorage, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
    currentFiltersInteractor.connectController(contentView.currentFiltersObservable)
    queryInputInteractor.connectController(contentView.queryInputObservable)
    filterClearInteractor.connectController(contentView.filterClearObservable)
  }
    
}

extension AlgoliaViewModel {
  static let test = AlgoliaViewModel(appID: "latency",
                                     apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                     indexName: "bestbuy",
                                     facetAttribute: "manufacturer")
}

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
          .frame(width: 100, height: 100, alignment: .leading)
        VStack(alignment: .leading, spacing: 5) {
          Text(highlightedString: highlightedTitle!, highlighted: { Text($0).foregroundColor(.blue) })
          Spacer()
            .frame(height: 1, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          Text(subtitle)
            .font(.system(size: 14, weight: .medium, design: .default))
          Text(details)
        }.multilineTextAlignment(.leading)
      }
      .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 100, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 140, maxHeight: 140, alignment: .leading)
      .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
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
  
}

struct SUIShopItem: Codable, Hashable, CustomStringConvertible {
  let objectID: String
  let name: String
  let manufacturer: String?
  let shortDescription: String?
  let image: URL?
  
  var description: String {
    return name
  }
}
