//
//  SearchView.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 10/04/2021.
//

import SwiftUI
import InstantSearch

struct SearchView: View {
  
  @ObservedObject var queryInputController: QueryInputObservableController
  @ObservedObject var hitsController: HitsObservableController<Hit<InstantSearchItem>>
  @ObservedObject var switchIndexController: SwitchIndexObservableController
  @ObservedObject var suggestionsController: HitsObservableController<QuerySuggestion>
  @ObservedObject var statsController: StatsObservableController
  @ObservedObject var loadingController: LoadingObservableController
    
  @State private var isEditing = false
    
  public init(queryInputController: QueryInputObservableController,
              hitsController: HitsObservableController<Hit<InstantSearchItem>>,
              switchIndexController: SwitchIndexObservableController,
              suggestionsController: HitsObservableController<QuerySuggestion>,
              statsController: StatsObservableController,
              loadingController: LoadingObservableController) {
    self.queryInputController = queryInputController
    self.hitsController = hitsController
    self.suggestionsController = suggestionsController
    self.switchIndexController = switchIndexController
    self.statsController = statsController
    self.loadingController = loadingController
  }
  
  var body: some View {
    VStack(spacing: 7) {
      SearchBar(text: $queryInputController.query,
                isEditing: $isEditing,
                onSubmit: queryInputController.submit)
      if isEditing {
        SuggestionsList(isEditing: $isEditing,
                        queryInputObservable: queryInputController,
                        suggestionsObservable: suggestionsController)
      } else {
        if loadingController.isLoading {
          VStack {
            Spacer()
            ProgressView("Search in progress...")
            Spacer()
          }
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
            HitsList(hitsController) { (hit, _) in
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
    }
    .navigationBarTitle("Algolia & SwiftUI")
    .padding([.horizontal, .top])
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

extension SearchView {
  
  init(viewModel: AlgoliaViewModel) {
    self.init(queryInputController: viewModel.queryInputController,
              hitsController: viewModel.hitsController,
              switchIndexController: viewModel.switchIndexController,
              suggestionsController: viewModel.suggestionsController,
              statsController: viewModel.statsController,
              loadingController: viewModel.loadingController)
  }
  
}

struct SearchView_Previews : PreviewProvider {
  
  static let algoliaController = AlgoliaController.test()
  
  static var previews: some View {
    SearchView(viewModel: algoliaController.viewModel)
  }
}
