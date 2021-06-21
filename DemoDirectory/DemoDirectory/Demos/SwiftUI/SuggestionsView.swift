//
//  SuggestionsView.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/04/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import SwiftUI

struct SuggestionsView: View {
  
  @Binding var isEditing: Bool
  @ObservedObject var queryInputController: QueryInputObservableController
  @ObservedObject var suggestionsController: HitsObservableController<QuerySuggestion>
  
  var body: some View {
    HitsList(suggestionsController) { (hit, _) in
      if let querySuggestion = hit {
        SuggestionRow(suggestion: querySuggestion) { suggestion in
          queryInputController.setQuery(suggestion)
          isEditing = false
        } onTypeAhead: { suggestion in
          queryInputController.setQuery(suggestion)
        }
      } else {
        EmptyView()
      }
      Divider()
    }
  }
  
}
