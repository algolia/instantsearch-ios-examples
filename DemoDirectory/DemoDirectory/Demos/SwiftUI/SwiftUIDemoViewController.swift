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
    UIScrollView.appearance().keyboardDismissMode = .interactive
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

struct ContentView: View {
  
  @ObservedObject var statsObservable: StatsObservableController
  @ObservedObject var hitsObservable: HitsObservableController<Hit<InstantSearchItem>>
  @ObservedObject var facetListObservable: FacetListObservableController
  @ObservedObject var currentFiltersObservable: CurrentFiltersObservableController
  @ObservedObject var queryInputObservable: QueryInputObservableController
  @ObservedObject var filterClearObservable: FilterClearObservable
  @ObservedObject var suggestionsObservable: HitsObservableController<QuerySuggestion>
  
  @State private var isPresentingFacets = false
  @State private var isEditing = false
  
  init() {
    statsObservable = .init()
    hitsObservable = .init()
    facetListObservable = .init()
    currentFiltersObservable = .init()
    queryInputObservable = .init()
    filterClearObservable = .init()
    suggestionsObservable = .init()
  }
  
  var body: some View {
      VStack(spacing: 7) {
        SmartSearchBar(text: $queryInputObservable.query,
                       isEditing: $isEditing,
                       submit: queryInputObservable.submit)
        if isEditing {
          suggestions()
        } else {
          results().onAppear {
            hideKeyboard()
          }
        }
      }
      .navigationBarTitle("Algolia & SwiftUI")
      .navigationBarItems(trailing: facetsButton())
  }
  
  private func suggestions() -> some View {
    HitsList(suggestionsObservable) { (hit, _) in
      if let querySuggestion = hit?.query {
        HStack {
          Text(querySuggestion)
            .padding(.vertical, 3)
          Spacer()
          Button(action: {
            queryInputObservable.setQuery(querySuggestion)
          }) {
            Image(systemName: "arrow.up.backward").foregroundColor(.gray)
          }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 20)
        .contentShape(Rectangle())
        .onTapGesture {
          queryInputObservable.setQuery(hit?.query)
          isEditing = false
        }
      } else {
        EmptyView()
      }
      Divider()
    }
  }
  
  private func results() -> some View {
    VStack {
      Text(statsObservable.stats)
        .fontWeight(.medium)
      HitsList(hitsObservable) { (hit, _) in
        ShopItemRow(isitem: hit)
      } noResults: {
        Text("No Results")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
  }
  
  private func facetsButton() -> some View {
    Button(action: { withAnimation { isPresentingFacets.toggle() } },
           label: {
            let imageName = currentFiltersObservable.isEmpty ? "line.horizontal.3.decrease.circle" : "line.horizontal.3.decrease.circle.fill"
            Image(systemName: imageName)
              .font(.title)
           }).sheet(isPresented: $isPresentingFacets,
                    content: facetsView)

  }
  
  @ViewBuilder
  private func facetContentView() -> some View {
    let facetList = FacetList(facetListObservable) { facet, isSelected in
      VStack {
        FacetRow(facet: facet, isSelected: isSelected)
        Divider()
      }
      .padding(.vertical, 7)
      .background(Color(.systemBackground))
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
  
  private func facetsView() -> some View {
    NavigationView {
      facetContentView()
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

    }
  }
}

class AlgoliaViewModel {
  
  let appID: ApplicationID
  let apiKey: APIKey
  let indexName: IndexName
  let facetAttribute: Attribute
  
  let searcher: SingleIndexSearcher
  let suggestionSearcher: SingleIndexSearcher
  let queryInputInteractor: QueryInputInteractor
  let hitsInteractor: HitsInteractor<Hit<InstantSearchItem>>
  let suggestionsInteractor: HitsInteractor<QuerySuggestion>
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
    self.searcher = SingleIndexSearcher(appID: appID,
                                        apiKey: apiKey,
                                        indexName: indexName)
    self.suggestionSearcher = .init(appID: appID,
                                    apiKey: "af044fb0788d6bb15f807e4420592bc5",
                                    indexName: "instantsearch_query_suggestions")
    self.hitsInteractor = .init()
    self.suggestionsInteractor = .init()
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
    suggestionsInteractor.connectSearcher(suggestionSearcher)
    queryInputInteractor.connectSearcher(suggestionSearcher)
  }
  
  func setup(_ contentView: ContentView) {
    hitsInteractor.connectController(contentView.hitsObservable)
    statsInteractor.connectController(contentView.statsObservable)
    facetListInteractor.connectController(contentView.facetListObservable, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
    currentFiltersInteractor.connectController(contentView.currentFiltersObservable)
    queryInputInteractor.connectController(contentView.queryInputObservable)
    filterClearInteractor.connectController(contentView.filterClearObservable)
    suggestionsInteractor.connectController(contentView.suggestionsObservable)
    searcher.search()
    suggestionSearcher.search()
  }
    
}

extension AlgoliaViewModel {
  static let test = AlgoliaViewModel(appID: "latency",
                                     apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                     indexName: "instant_search",
                                     facetAttribute: "brand")
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
          .frame(width: 100, height: 100, alignment: .topLeading)
        VStack(alignment: .leading, spacing: 5) {
          Text(highlightedString: highlightedTitle!, highlighted: { Text($0).foregroundColor(.blue) })
            .font(.system(.headline))
          Spacer()
            .frame(height: 1, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
          Text(subtitle)
            .font(.system(size: 14, weight: .medium, design: .default))
          Text(details)
            .font(.system(.caption))
            .foregroundColor(.gray)
        }.multilineTextAlignment(.leading)
      }
      .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 100, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 140, maxHeight: 140, alignment: .leading)
      .padding(.horizontal, 20)
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
  
  init(isitem: Hit<InstantSearchItem>?) {
    guard let item = isitem?.object else {
      self = .init()
      return
    }
    self.title = item.name
    self.subtitle = item.brand ?? ""
    self.details = item.description ?? ""
    self.imageURL = item.image ?? URL(string: "google.com")!
    self.highlightedTitle = isitem?.hightlightedString(forKey: "name")
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

struct SmartSearchBar: View {
  
  @Binding public var text: String
  @Binding public var isEditing: Bool
  public var submit: () -> Void
  
  var body: some View {
    HStack {
      TextField("Search ...", text: $text, onCommit: {
        submit()
        isEditing = false
      })
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
              text = ""
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
        isEditing = true
        //              mode = .suggestions
      }
      if isEditing {
        Button(action: {
          isEditing = false
          //            queryInputObservable.query = ""
          //            mode = .hits
          //            hideKeyboard()
        }) {
          Text("Cancel")
        }
        .padding(.trailing, 10)
        .transition(.move(edge: .trailing))
        .animation(.default)
      }
    }
  }
}
