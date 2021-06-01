//
//  AlgoliaController.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 10/04/2021.
//

import Foundation
import InstantSearch
import Combine

class AlgoliaController {
  
  let appID: ApplicationID
  let apiKey: APIKey
  let indexName: IndexName
  let facetAttribute: Attribute
  
  let suggestions: SuggestionsViewModel
  let facetSearch: FacetSearchViewModel
  
  let searcher: SingleIndexSearcher
  let queryInputInteractor: QueryInputInteractor
  let hitsInteractor: HitsInteractor<Hit<InstantSearchItem>>
  let statsInteractor: StatsInteractor
  let currentFiltersInteractor: CurrentFiltersInteractor
  let filterState: FilterState
  let filterClearInteractor: FilterClearInteractor
  let switchIndexInteractor: SwitchIndexInteractor
  let hierarchicalInteractor: HierarchicalInteractor
  
  
  let ratingFacetListInteractor: FacetListInteractor
  let priceInteractor: NumberRangeInteractor<Int>
  
  let freeShippingToggleInteractor: SelectableInteractor<Filter.Facet>
  
  let viewModel = AlgoliaViewModel()
    
  struct HierarchicalCategory {
    static var base: Attribute = "hierarchicalCategories"
    static var lvl0: Attribute { return Attribute(rawValue: base.description + ".lvl0")  }
    static var lvl1: Attribute { return Attribute(rawValue: base.description + ".lvl1") }
    static var lvl2: Attribute { return Attribute(rawValue: base.description + ".lvl2") }
    static var lvl3: Attribute { return Attribute(rawValue: base.description + ".lvl3") }
  }
  
  let order = [
    HierarchicalCategory.lvl0,
    HierarchicalCategory.lvl1,
    HierarchicalCategory.lvl2,
    HierarchicalCategory.lvl3
  ]
    
  init(appID: ApplicationID,
       apiKey: APIKey,
       indexName: IndexName,
       facetAttribute: Attribute) {
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
    self.ratingFacetListInteractor = .init()
    self.facetSearch = .init(appID: appID,
                             apiKey: apiKey,
                             indexName: indexName,
                             facetAttribute: facetAttribute)
    self.hierarchicalInteractor = .init(hierarchicalAttributes: order, separator: " > ")
    self.freeShippingToggleInteractor = .init(item: .init(attribute: "free_shipping", boolValue: true))
    self.priceInteractor = .init()
    searcher.disjunctiveFacetsAttributes.insert("rating")
    setupConnections()
  }
  
  fileprivate func setupConnections() {
    searcher.connectFilterState(filterState)
    hitsInteractor.connectSearcher(searcher)
    statsInteractor.connectSearcher(searcher)
    currentFiltersInteractor.connectFilterState(filterState, filterGroupIDs: [
                                                  .hierarchical(name: "_hierarchical"),
                                                  .or(name: "brand", filterType: .facet),
                                                  .or(name: "free_shipping", filterType: .facet),
                                                  .or(name: "rating", filterType: .facet)
    ])
    queryInputInteractor.connectSearcher(searcher)
    filterClearInteractor.connectFilterState(filterState,
                                             filterGroupIDs: [],
                                             clearMode: .except)
    switchIndexInteractor.connectSearcher(searcher)
    
    queryInputInteractor.connectSearcher(suggestions.searcher)
    
    facetSearch.searcher.connectFilterState(filterState)
    facetSearch.facetListInteractor.connectFilterState(filterState, with: facetAttribute, operator: .or)

    hierarchicalInteractor.connectSearcher(searcher: searcher)
    hierarchicalInteractor.connectFilterState(filterState)
    
    freeShippingToggleInteractor.connectFilterState(filterState)
    
    ratingFacetListInteractor.connectSearcher(searcher, with: "rating")
    ratingFacetListInteractor.connectFilterState(filterState, with: "rating", operator: .or)
    
    priceInteractor.connectSearcher(searcher, attribute: "price")
    priceInteractor.connectFilterState(filterState, attribute: "price")
    
    connectVM()
  }
    
  func connectVM() {
    
    statsInteractor.connectController(viewModel.statsController)

    hitsInteractor.connectController(viewModel.hitsController)
    queryInputInteractor.connectController(viewModel.queryInputController)
    switchIndexInteractor.connectController(viewModel.switchIndexController)
    suggestions.hitsInteractor.connectController(viewModel.suggestionsController)
    suggestions.searcher.search()

    currentFiltersInteractor.connectController(viewModel.currentFiltersController)
    
    filterClearInteractor.connectController(viewModel.filterClearController)
    ratingFacetListInteractor.connectController(viewModel.ratingController)
    hierarchicalInteractor.connectController(viewModel.categoryHierarchicalController)

    viewModel.ratingController.didChangeSelected = { [weak self] rating in
      self?.filterState[or: "rating", Filter.Facet.self].removeAll()
      if let rating = rating {
        let filters = (rating...5).map { Filter.Facet(attribute: "rating", stringValue: "\($0)") }
        self?.filterState[or: "rating"].addAll(filters)
      }
      self?.filterState.notifyChange()
    }
    
    facetSearch.facetListInteractor.connectController(viewModel.facetListController, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
    facetSearch.queryInputInteractor.connectController(viewModel.facetSearchQueryInputController)

    freeShippingToggleInteractor.connectController(viewModel.freeShippingToggleController)
    
    priceInteractor.connectController(viewModel.priceRangeController)
    facetSearch.searcher.search()
    
    searcher.search()
  }

  
  class SuggestionsViewModel {
    
    let searcher: SingleIndexSearcher
    let hitsInteractor: HitsInteractor<QuerySuggestion>

    init() {
      searcher = .init(appID: "latency",
                                 apiKey: "af044fb0788d6bb15f807e4420592bc5",
                                 indexName: "instantsearch_query_suggestions")
      searcher.indexQueryState.query.hitsPerPage = 20
      hitsInteractor = .init(infiniteScrolling: .off)
      hitsInteractor.connectSearcher(searcher)
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
      query.maxFacetHits = 10
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
      
  }
  
}

extension AlgoliaController {
  static func test() -> AlgoliaController {
    AlgoliaController(appID: "latency",
                     apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                     indexName: "instant_search",
                     facetAttribute: "brand")
  }
}

class AlgoliaViewModel: ObservableObject {
  var queryInputController: QueryInputObservableController = .init()
  var statsController: StatsObservableController = .init()
  var hitsController: HitsObservableController<Hit<InstantSearchItem>> = .init()
  var switchIndexController: SwitchIndexObservableController = .init()
  var suggestionsController: HitsObservableController<QuerySuggestion> = .init()
  var currentFiltersController: CurrentFiltersObservableController = .init()
  var facetSearchQueryInputController: QueryInputObservableController = .init()
  var facetListController: FacetListObservableController = .init()
  var filterClearController: FilterClearObservableController = .init()
  var categoryHierarchicalController: HierarchicalObservableController = .init()
  var freeShippingToggleController: FilterToggleObservableController<Filter.Facet> = .init(isSelected: false)
  var ratingController: RatingController = .init()
  var priceRangeController: RangeController = .init(range: 0...1, bounds: 0...1)
}
