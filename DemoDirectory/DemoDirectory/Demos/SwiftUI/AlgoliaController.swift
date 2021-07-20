//
//  AlgoliaController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class AlgoliaController {
  
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
    hitsInteractor.connectController(contentView.hitsController)
    statsInteractor.connectController(contentView.statsController)
    currentFiltersInteractor.connectController(contentView.currentFiltersController)
    queryInputInteractor.connectController(contentView.queryInputController)
    filterClearInteractor.connectController(contentView.filterClearController)
    switchIndexInteractor.connectController(contentView.switchIndexController)
    
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
      hitsInteractor.connectController(contentView.suggestionsController)
      searcher.search()
    }
    
  }
    
  class FacetListViewModel {
    
    let facetListInteractor: FacetListInteractor

    init() {
      facetListInteractor = .init()
    }
    
    func setup(_ contentView: ContentView) {
      facetListInteractor.connectController(contentView.facetListController, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
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
      facetListInteractor.connectController(contentView.facetListController, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
      queryInputInteractor.connectController(contentView.facetSearchQueryInputController)
    }
  
  }
  
}

extension AlgoliaController {
  static func test(areFacetsSearchable: Bool) -> AlgoliaController {
    AlgoliaController(appID: "latency",
                     apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                     indexName: "instant_search",
                     facetAttribute: "brand",
                     areFacetsSearchable: areFacetsSearchable)
  }
}
