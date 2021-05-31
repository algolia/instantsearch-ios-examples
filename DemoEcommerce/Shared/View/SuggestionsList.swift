//
//  SuggestionsList.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 10/04/2021.
//

import Foundation
import SwiftUI
import InstantSearch

struct SuggestionsList: View {
  
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
