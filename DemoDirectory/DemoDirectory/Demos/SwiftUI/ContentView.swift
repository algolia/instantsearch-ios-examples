//
//  ContentView.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import SwiftUI

struct ContentView: View {
  
  let areFacetsSearchable: Bool
  let allowSuggestions: Bool = true
  
  @ObservedObject var queryInputController: QueryInputObservableController
  @ObservedObject var statsController: StatsObservableController
  @ObservedObject var hitsController: HitsObservableController<Hit<InstantSearchItem>>
  
  // Shared models
  @ObservedObject var currentFiltersController: CurrentFiltersObservableController
  @ObservedObject var switchIndexController: SwitchIndexObservableController

  // Suggestions models
  @ObservedObject var suggestionsController: HitsObservableController<QuerySuggestion>
  
  // Facet list models
  @ObservedObject var facetSearchQueryInputController: QueryInputObservableController
  @ObservedObject var facetListController: FacetListObservableController
  @ObservedObject var filterClearController: FilterClearObservable
  
  // State
  @State private var isPresentingFacets = false
  @State private var isEditing = false
  
  @Environment(\.presentationMode) var presentation
  
  init(areFacetsSearchable: Bool) {
    statsController = .init()
    hitsController = .init()
    currentFiltersController = .init()
    queryInputController = .init()
    filterClearController = .init()
    suggestionsController = .init()
    switchIndexController = .init()
    facetSearchQueryInputController = .init()
    facetListController = .init()
    self.areFacetsSearchable = areFacetsSearchable
  }
  
  var body: some View {
      VStack(spacing: 7) {
        SearchBar(text: $queryInputController.query,
                  isEditing: $isEditing,
                  onSubmit: queryInputController.submit)
        if isEditing && allowSuggestions {
          SuggestionsView(isEditing: $isEditing,
                          queryInputController: queryInputController,
                          suggestionsController: suggestionsController)
        } else {
          VStack {
            HStack {
              Text(statsController.stats)
                .fontWeight(.medium)
              Spacer()
              if #available(iOS 14.0, *) {
                sortMenu()
              }
            }
            HitsList(hitsController) { (hit, index) in
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
      .padding()
      .navigationBarTitle("Algolia & SwiftUI")
      .navigationBarItems(trailing: facetsButton())
      .sheet(isPresented: $isPresentingFacets) {
        NavigationView {
          FacetsView(isSearchable: areFacetsSearchable,
                     facetSearchQueryInputController: facetSearchQueryInputController,
                     facetListController: facetListController,
                     statsController: statsController,
                     currentFiltersController: currentFiltersController,
                     filterClearController: filterClearController)
        }
      }
  }
  
  @available(iOS 14.0, *)
  private func sortMenu() -> some View {
    Menu {
      ForEach(0 ..< switchIndexController.indexNames.count, id: \.self) { index in
        let indexName = switchIndexController.indexNames[index]
        Button(label(for: indexName)) {
          switchIndexController.select(indexName)
        }
      }
    } label: {
      Label(label(for: switchIndexController.selected), systemImage: "arrow.up.arrow.down.circle")
    }
  }
  
  private func facetsButton() -> some View {
    Button(action: {
      withAnimation {
        isPresentingFacets.toggle()
      }
    },
    label: {
      let imageName = currentFiltersController.isEmpty ? "line.horizontal.3.decrease.circle" : "line.horizontal.3.decrease.circle.fill"
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

struct ContentView_Previews : PreviewProvider {
  
  static let viewModel = AlgoliaController.test(areFacetsSearchable: true)
  
  static var previews: some View {
    let contentView = ContentView(areFacetsSearchable: viewModel.areFacetsSearchable)
    let _ = viewModel.setup(contentView)
    NavigationView {
      contentView
    }
  }
  
}
