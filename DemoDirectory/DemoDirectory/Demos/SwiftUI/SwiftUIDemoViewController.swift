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

class SwiftUIDemoViewController: UIHostingController<ContentView> {
  
  let viewModel = AlgoliaViewModel.test
  
  init() {
    let contentView = ContentView()
    super.init(rootView: contentView)
    viewModel.setup(contentView)
    viewModel.searcher.search()
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension AlgoliaViewModel {
  static let test = AlgoliaViewModel(appID: "latency",
                                     apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                     indexName: "bestbuy",
                                     facetAttribute: "manufacturer")
}

struct ContentView: View {
  
  @State private var showFacets = false
  
  @ObservedObject var statsObservable: StatsObservable = .init()
  @ObservedObject var hitsObservable: HitsObservable<SUIShopItem> = .init()
  @ObservedObject var facetStorage: FacetStorage = .init()
  @ObservedObject var currentFiltersObservable: CurrentFiltersObservable = .init()
  @ObservedObject var queryInputObservable: QueryInputObservable = .init()
  
  var body: some View {
    return VStack(spacing: 10) {
      SearchBar(text: $queryInputObservable.query)
      Text(statsObservable.stats)
        .fontWeight(.medium)
      HitsView(hitsObservable) { (item, _) in
        ShopItemRow(item: item)
      } noResults: {
        Text("No Results")
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      }
    }
    .navigationBarTitle("Algolia & SwiftUI")
    .navigationBarItems(trailing:
                          Button(action: { withAnimation { showFacets.toggle() } },
                                 label: {
                                  if currentFiltersObservable.isEmpty {
                                    Image(systemName: "line.horizontal.3.decrease.circle")
                                      .font(.title)
                                  } else {
                                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                                      .font(.title)
                                  }
                                 }).sheet(isPresented: $showFacets, content: {
                                  NavigationView {
                                    FacetsScreen(statsObservable: statsObservable,
                                                 facetStorage: facetStorage)
                                  }
                                 })
    )
  }
}

struct FacetsScreen: View {
  
  @ObservedObject var statsObservable: StatsObservable
  @ObservedObject var facetStorage: FacetStorage
  
  var body: some View {
    VStack {
      Text(statsObservable.stats)
        .fontWeight(.medium)
      FacetListView(facetStorage: facetStorage)
    }
    .navigationBarTitle("Manufacturer")
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
  let hitsInteractor: HitsInteractor<SUIShopItem>
  let statsInteractor: StatsInteractor
  let facetListInteractor: FacetListInteractor
  let currentFiltersInteractor: CurrentFiltersInteractor
  let filterState: FilterState
    
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
  }
  
  func setup(_ contentView: ContentView) {
    hitsInteractor.connectController(contentView.hitsObservable)
    statsInteractor.connectController(contentView.statsObservable)
    facetListInteractor.connectController(contentView.facetStorage, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
    currentFiltersInteractor.connectController(contentView.currentFiltersObservable)
    queryInputInteractor.connectController(contentView.queryInputObservable)
  }
    
}

struct SUIShopItem: Codable, Hashable {
  let objectID: String
  let name: String
  let manufacturer: String?
  let shortDescription: String?
  let image: URL?
}

