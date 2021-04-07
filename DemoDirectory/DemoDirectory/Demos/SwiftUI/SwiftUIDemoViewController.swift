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
  
  let viewModel = AlgoliaViewModel.test(areFacetsSearchable: true)
  
  init() {
    let contentView = ContentView(areFacetsSearchable: true)
    super.init(rootView: contentView)
    viewModel.setup(contentView)
    UIScrollView.appearance().keyboardDismissMode = .interactive
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

struct ContentView: View {
  
  let areFacetsSearchable: Bool
  
  @ObservedObject var queryInputObservable: QueryInputObservableController
  @ObservedObject var statsObservable: StatsObservableController
  @ObservedObject var hitsObservable: HitsObservableController<Hit<InstantSearchItem>>
  
  // Shared models
  @ObservedObject var currentFiltersObservable: CurrentFiltersObservableController
  @ObservedObject var switchIndexObservable: SwitchIndexObservableController


  // Suggestions models
  @ObservedObject var suggestionsObservable: HitsObservableController<QuerySuggestion>
  
  // Facet list models
  @ObservedObject var facetSearchQueryInputObservable: QueryInputObservableController
  @ObservedObject var facetListObservable: FacetListObservableController
  @ObservedObject var filterClearObservable: FilterClearObservable
  
  // State
  @State private var isPresentingFacets = false
  @State private var isEditing = false
  
  @Environment(\.presentationMode) var presentation
  
  init(areFacetsSearchable: Bool) {
    statsObservable = .init()
    hitsObservable = .init()
    currentFiltersObservable = .init()
    queryInputObservable = .init()
    filterClearObservable = .init()
    suggestionsObservable = .init()
    switchIndexObservable = .init()
    facetSearchQueryInputObservable = .init()
    facetListObservable = .init()
    self.areFacetsSearchable = areFacetsSearchable
  }
  
  var body: some View {
      VStack(spacing: 7) {
        SearchBar(text: $queryInputObservable.query,
                  isEditing: $isEditing,
                  onSubmit: queryInputObservable.submit)
        if isEditing {
          Suggestions(isEditing: $isEditing,
                      queryInputObservable: queryInputObservable,
                      suggestionsObservable: suggestionsObservable)
        } else {
          VStack {
            HStack {
              Text(statsObservable.stats)
                .fontWeight(.medium)
              Spacer()
              if #available(iOS 14.0, *) {
                sortMenu()
              }
            }.padding(.horizontal, 20)
            HitsList(hitsObservable) { (hit, _) in
              ShopItemRow(isitem: hit)
            } noResults: {
              Text("No Results")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
          }
          .onAppear {
            hideKeyboard()
          }
        }
      }
      .navigationBarTitle("Algolia & SwiftUI")
      .navigationBarItems(trailing: facetsButton())
      .sheet(isPresented: $isPresentingFacets) {
        NavigationView {
          Facets(isSearchable: areFacetsSearchable,
                 facetSearchQueryInputObservable: facetSearchQueryInputObservable,
                 facetListObservable: facetListObservable,
                 statsObservable: statsObservable,
                 currentFiltersObservable: currentFiltersObservable,
                 filterClearObservable: filterClearObservable)
        }
      }
  }
  
  @available(iOS 14.0, *)
  private func sortMenu() -> some View {
    Menu {
      ForEach(0 ..< switchIndexObservable.indexNames.count, id: \.self) { index in
        let indexName = switchIndexObservable.indexNames[index]
        Button(label(for: indexName)) {
          switchIndexObservable.select(indexName)
        }
      }
    } label: {
      Label(label(for: switchIndexObservable.selected), systemImage: "arrow.up.arrow.down.circle")
    }
  }
  
  private func facetsButton() -> some View {
    Button(action: {
      withAnimation {
        isPresentingFacets.toggle()
      }
    },
    label: {
      let imageName = currentFiltersObservable.isEmpty ? "line.horizontal.3.decrease.circle" : "line.horizontal.3.decrease.circle.fill"
      Image(systemName: imageName)
        .font(.title)
    })
  }
  
  private func label(for indexName: IndexName) -> String {
    switch indexName {
    case "instant_search":
      return "Featured"
    case "instant_search_price_asc":
      return "Price ascending"
    case "instant_search_price_desc":
      return "Price descending"
    default:
      return indexName.rawValue
    }
  }
  
}

struct Suggestions: View {
  
  @Binding var isEditing: Bool
  @ObservedObject var queryInputObservable: QueryInputObservableController
  @ObservedObject var suggestionsObservable: HitsObservableController<QuerySuggestion>
  
  var body: some View {
    HitsList(suggestionsObservable) { (hit, _) in
      if let querySuggestion = hit?.query {
        SuggestionRow(text: querySuggestion) { suggestion in
          queryInputObservable.setQuery(suggestion)
          isEditing = false
        } onTypeAhead: { suggestion in
          queryInputObservable.setQuery(suggestion)
        }
      } else {
        EmptyView()
      }
      Divider()
    }
  }
  
}

struct Facets: View {

  let isSearchable: Bool
  
  @ObservedObject var facetSearchQueryInputObservable: QueryInputObservableController
  @ObservedObject var facetListObservable: FacetListObservableController
  @ObservedObject var statsObservable: StatsObservableController
  @ObservedObject var currentFiltersObservable: CurrentFiltersObservableController
  @ObservedObject var filterClearObservable: FilterClearObservable

  @State private var isEditingFacetSearch = false
  
  var body: some View {
    let facetList =
    VStack {
      if isSearchable {
        SearchBar(text: $facetSearchQueryInputObservable.query,
                  isEditing: $isEditingFacetSearch,
                  placeholder: "Search for facet")
      }
      FacetList(facetListObservable) { facet, isSelected in
        VStack {
          FacetRow(facet: facet, isSelected: isSelected)
          Divider()
        }
        .padding(.vertical, 7)
      } noResults: {
        Text("No facets found")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .navigationBarTitle("Brand")
    
    if #available(iOS 14.0, *) {
      facetList.toolbar {
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
      facetList
    }
    
  }
  
}

struct ContentView_Previews : PreviewProvider {
  
  static let viewModel = AlgoliaViewModel.test(areFacetsSearchable: true)
  
  static var previews: some View {
    let contentView = ContentView(areFacetsSearchable: viewModel.areFacetsSearchable)
    let _ = viewModel.setup(contentView)
    NavigationView {
      contentView
    }
  }
}



class AlgoliaViewModel {
  
  let appID: ApplicationID
  let apiKey: APIKey
  let indexName: IndexName
  let facetAttribute: Attribute
  
  let suggestions: SuggestionsViewModel
  let facetList: FacetListViewModel
  let facetSearch: FacetSearchViewModel
  
  let searcher: SingleIndexSearcher
  let queryInputInteractor: QueryInputInteractor
  let hitsInteractor: HitsInteractor<Hit<InstantSearchItem>>
  let statsInteractor: StatsInteractor
  let currentFiltersInteractor: CurrentFiltersInteractor
  let filterState: FilterState
  let filterClearInteractor: FilterClearInteractor
  let switchIndexInteractor: SwitchIndexInteractor
  
  let areFacetsSearchable: Bool
    
  init(appID: ApplicationID,
       apiKey: APIKey,
       indexName: IndexName,
       facetAttribute: Attribute,
       areFacetsSearchable: Bool) {
    self.appID = appID
    self.apiKey = apiKey
    self.indexName = indexName
    self.facetAttribute = facetAttribute
    self.searcher = SingleIndexSearcher(appID: appID,
                                        apiKey: apiKey,
                                        indexName: indexName)
    self.hitsInteractor = .init()
    self.statsInteractor = .init()
    self.filterState = .init()
    self.currentFiltersInteractor = .init()
    self.queryInputInteractor = .init()
    self.filterClearInteractor = .init()
    self.switchIndexInteractor = .init(
      indexNames: [
        "instant_search",
        "instant_search_price_asc",
        "instant_search_price_desc"
      ],
      selectedIndexName: "instant_search")
    self.suggestions = .init()
    self.facetList = .init()
    self.facetSearch = .init(appID: appID,
                             apiKey: apiKey,
                             indexName: indexName,
                             facetAttribute: facetAttribute)
    self.areFacetsSearchable = areFacetsSearchable
    setupConnections()
  }
  
  fileprivate func setupConnections() {
    searcher.connectFilterState(filterState)
    hitsInteractor.connectSearcher(searcher)
    statsInteractor.connectSearcher(searcher)
    currentFiltersInteractor.connectFilterState(filterState)
    queryInputInteractor.connectSearcher(searcher)
    filterClearInteractor.connectFilterState(filterState,
                                             filterGroupIDs: [.or(name: facetAttribute.rawValue, filterType: .facet)],
                                             clearMode: .specified)
    switchIndexInteractor.connectSearcher(searcher)
    
    queryInputInteractor.connectSearcher(suggestions.searcher)
    
    if areFacetsSearchable {
      facetSearch.searcher.connectFilterState(filterState)
      facetSearch.facetListInteractor.connectFilterState(filterState, with: facetAttribute, operator: .or)
    } else {
      facetList.facetListInteractor.connectSearcher(searcher, with: facetAttribute)
      facetList.facetListInteractor.connectFilterState(filterState, with: facetAttribute, operator: .or)
    }
    
  }
  
  func setup(_ contentView: ContentView) {
    hitsInteractor.connectController(contentView.hitsObservable)
    statsInteractor.connectController(contentView.statsObservable)
    currentFiltersInteractor.connectController(contentView.currentFiltersObservable)
    queryInputInteractor.connectController(contentView.queryInputObservable)
    filterClearInteractor.connectController(contentView.filterClearObservable)
    switchIndexInteractor.connectController(contentView.switchIndexObservable)
    
    suggestions.setup(contentView)
    
    if areFacetsSearchable {
      facetSearch.setup(contentView)
    } else {
      facetList.setup(contentView)
    }
    
    searcher.search()
  }
  
  class SuggestionsViewModel {
    
    let searcher: SingleIndexSearcher
    let hitsInteractor: HitsInteractor<QuerySuggestion>

    init() {
      searcher = .init(appID: "latency",
                                 apiKey: "af044fb0788d6bb15f807e4420592bc5",
                                 indexName: "instantsearch_query_suggestions")
      hitsInteractor = .init()
      hitsInteractor.connectSearcher(searcher)
    }

    func setup(_ contentView: ContentView) {
      hitsInteractor.connectController(contentView.suggestionsObservable)
      searcher.search()
    }
    
  }
    
  class FacetListViewModel {
    
    let facetListInteractor: FacetListInteractor

    init() {
      facetListInteractor = .init()
    }
    
    func setup(_ contentView: ContentView) {
      facetListInteractor.connectController(contentView.facetListObservable, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
    }
    
  }
  
  class FacetSearchViewModel {
    
    let searcher: FacetSearcher
    let queryInputInteractor: QueryInputInteractor
    let facetListInteractor: FacetListInteractor

    init(appID: ApplicationID,
         apiKey: APIKey,
         indexName: IndexName,
         facetAttribute: Attribute) {
      var query = Query()
      query.maxFacetHits = 100
      searcher = .init(appID: appID,
                       apiKey: apiKey,
                       indexName: indexName,
                       facetName: facetAttribute,
                       query: query,
                       requestOptions: nil)
      queryInputInteractor = .init()
      facetListInteractor = .init()

      queryInputInteractor.connectSearcher(searcher)
      facetListInteractor.connectFacetSearcher(searcher)
      
      searcher.search()
    }
    
    func setup(_ contentView: ContentView) {
      facetListInteractor.connectController(contentView.facetListObservable, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
      queryInputInteractor.connectController(contentView.facetSearchQueryInputObservable)
    }
  
  }
  
}

extension AlgoliaViewModel {
  static func test(areFacetsSearchable: Bool) -> AlgoliaViewModel {
    AlgoliaViewModel(appID: "latency",
                     apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                     indexName: "instant_search",
                     facetAttribute: "brand",
                     areFacetsSearchable: areFacetsSearchable)
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

struct InstantSearchItem: Codable, Hashable {
  
  let objectID: String
  let name: String
  let brand: String?
  let description: String?
  let image: URL?
  let price: Double?
  
}
