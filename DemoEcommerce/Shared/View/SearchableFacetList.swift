//
//  SearchableFacets.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 10/04/2021.
//

import Foundation
import InstantSearch
import SwiftUI

struct SearchableFacetList: View {
  
  @ObservedObject var facetSearchQueryInputController: QueryInputObservableController
  @ObservedObject var facetListController: FacetListObservableController

  @State private var isEditingFacetSearch = false
  
  var body: some View {
    VStack {
      SearchBar(text: $facetSearchQueryInputController.query,
                isEditing: $isEditingFacetSearch,
                placeholder: "Brand name...")
      FacetList(facetListController) { facet, isSelected in
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
  }
  
}

