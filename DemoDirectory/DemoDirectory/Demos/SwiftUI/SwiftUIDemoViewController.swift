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
  
  let viewModel = AlgoliaViewModel()

  init() {
    let contentView = ContentView()
    viewModel.setup(contentView)
    super.init(rootView: contentView)
    viewModel.searcher.search()
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

class AlgoliaViewModel {
  
  let searcher: SingleIndexSearcher
  let hitsInteractor: HitsInteractor<SUIShopItem>
  let statsInteractor: StatsInteractor
  let facetListInteractor: FacetListInteractor
  let filterState: FilterState
  
  init() {
    InstantSearchCoreLogger.minLogSeverityLevel = .trace
    Logger.minSeverityLevel = .trace
    let searcher = SingleIndexSearcher(appID: "latency",
    apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
    indexName: "bestbuy")
    self.searcher = searcher
    self.hitsInteractor = .init()
    self.statsInteractor = .init()
    self.facetListInteractor = .init()
    self.filterState = .init()
    searcher.connectFilterState(filterState)
    hitsInteractor.connectSearcher(searcher)
    facetListInteractor.connectSearcher(searcher, with: "manufacturer")
    facetListInteractor.connectFilterState(filterState, with: "manufacturer", operator: .or)
    statsInteractor.connectSearcher(searcher)
  }
  
  func setup(_ contentView: ContentView) {
    contentView.queryDispatcher.searcher = searcher
    hitsInteractor.connectController(contentView.hitsObservable)
    statsInteractor.connectController(contentView.statsObservable)
    facetListInteractor.connectController(contentView.facetListObservable, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
  }
    
}

struct ContentView: View {
  
  @State private var showFacets = false
  
  @ObservedObject var queryDispatcher: QueryDispatcher = .init()
  @ObservedObject var statsObservable: StatsObservable = .init()
  @ObservedObject var hitsObservable: HitsObservable<SUIShopItem> = .init()
  @ObservedObject var facetListObservable: FacetListObservable = .init()
  
  var body: some View {
    return VStack(spacing: 10) {
      SearchBar(text: $queryDispatcher.query)
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
                                  Image(systemName: "line.horizontal.3.decrease.circle")
                                    .font(.title)
                                 }).sheet(isPresented: $showFacets, content: {
                                  NavigationView {
                                    FacetsScreen(statsObservable: statsObservable,
                                                facetListObservable: facetListObservable)
                                  }
                                 })
    )
  }
}

struct ContentView_Previews : PreviewProvider {
  
  static let viewModel = AlgoliaViewModel()
  
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

struct FacetsScreen: View {
  
  @ObservedObject var statsObservable: StatsObservable
  @ObservedObject var facetListObservable: FacetListObservable
  
  var body: some View {
    VStack {
      Text(statsObservable.stats)
        .fontWeight(.medium)
      FacetListView(facets: $facetListObservable.facets,
                    select: facetListObservable.onClick!)
    }
    .navigationBarTitle("Manufacturer")
  }
  
}
