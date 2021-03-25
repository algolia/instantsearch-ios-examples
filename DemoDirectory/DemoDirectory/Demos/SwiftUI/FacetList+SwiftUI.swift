//
//  FacetList+SwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25/03/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import SwiftUI
import InstantSearchCore

class FacetListObservable: ObservableObject, FacetListController {
  
  @Published var facets: [(Facet, Bool)] = []
  
  var onClick: ((Facet) -> Void)?
        
  func setSelectableItems(selectableItems: [SelectableItem<Facet>]) {
    DispatchQueue.main.async {
      self.facets = selectableItems
    }
  }
  
  func reload() {
    objectWillChange.send()
  }

}

struct FacetListView: View {

  @Binding var facets: [(Facet, Bool)]
  var select: (Facet) -> Void

  var body: some View {
    ScrollView(showsIndicators: true) {
      VStack() {
        ForEach(facets, id: \.0) { (facet, isSelected) in
          FacetRow(facet: facet, isSelected: isSelected)
            .onTapGesture { select(facet) }
          Divider()
        }
      }.background(Color(.systemBackground))
    }
  }

}

struct FacetRow: View {
  
  var facet: Facet
  var isSelected: Bool
  
  var body: some View {
    HStack {
      Text(facet.description)
        .font(.footnote)
        .frame(maxWidth: .infinity, minHeight: 30, alignment: .leading)
        .padding(.leading, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
      if isSelected {
        Image(systemName: "checkmark")
          .font(.footnote)
          .frame(minWidth: 44, alignment: .trailing)
          .padding(.trailing, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
      }
    }
  }
}
