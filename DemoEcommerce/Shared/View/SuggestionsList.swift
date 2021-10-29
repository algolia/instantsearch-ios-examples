//
//  SuggestionsList.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 10/04/2021.
//

import Foundation
import SwiftUI
import InstantSearch
import InstantSearchSwiftUI

struct SuggestionsList: View {
  
  @Binding var isEditing: Bool
  @ObservedObject var queryInputObservable: QueryInputObservableController
  @ObservedObject var suggestionsObservable: HitsObservableController<QuerySuggestion>
  
  var body: some View {
    HitsList(suggestionsObservable) { (suggestion, _) in
      if let suggestion = suggestion {
        SuggestionRow(suggestion: suggestion,
                      onSelection: { suggestion in
                        queryInputObservable.setQuery(suggestion)
                        isEditing = false
                      },
                      onTypeAhead: { suggestion in
                        queryInputObservable.setQuery(suggestion)
                      })
        Divider()
      } else {
        Color(.systemGreen)
      }
    }
  }
  
}
