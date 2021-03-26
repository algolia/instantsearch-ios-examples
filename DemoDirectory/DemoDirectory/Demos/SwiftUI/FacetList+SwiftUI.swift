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

class FacetStorage: ObservableObject, FacetListController {
  
  @Published var facets: [Facet]
  @Published var selections: Set<String>
  
  var onClick: ((Facet) -> Void)?
  
  init(facets: [Facet] = [], selections: Set<String> = [], onClick: ((Facet) -> Void)? = nil) {
    self.facets = facets
    self.selections = selections
    self.onClick = onClick
  }
  
  func select(_ facet: Facet) {
    onClick?(facet)
  }
  
  func isSelected(_ facet: Facet) -> Bool {
    return selections.contains(facet.value)
  }
  
  func setSelectableItems(selectableItems: [SelectableItem<Facet>]) {
    self.facets = selectableItems.map(\.item)
    self.selections = Set(selectableItems.filter(\.isSelected).map(\.item.value))
  }
  
  func reload() {
    objectWillChange.send()
  }
  
}

struct FacetListView: View {

  @ObservedObject var facetStorage: FacetStorage

  var body: some View {
    ScrollView(showsIndicators: true) {
      VStack() {
        ForEach(facetStorage.facets, id: \.self) { facet in
          FacetRow(facet: facet, isSelected: facetStorage.isSelected(facet))
            .onTapGesture {
              facetStorage.select(facet)
            }
          Divider()
        }
      }
    }
  }

}

struct FacetRow: View {
  
  var facet: Facet
  var isSelected: Bool
  
  var body: some View {
    HStack(spacing: 0) {
      Text(facet.description)
        .font(.footnote)
        .frame(maxWidth: .infinity, minHeight: 30, maxHeight: .infinity, alignment: .leading)
      if isSelected {
        Image(systemName: "checkmark")
          .font(.footnote)
          .frame(maxHeight: .infinity, alignment: .trailing)
      }
    }
    .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    .background(Color(.systemBackground))
  }
  
}

struct Facets_Previews : PreviewProvider {
  
  static let test: [Facet] = {
    [
      ("Samsung", 356),
      ("Sony", 236),
      ("Insignia", 230),
      ("Dynex", 202),
      ("RocketFish", 193),
      ("HP", 192),
      ("Apple", 162),
      ("LG", 141),
      ("Metra", 132),
      ("Microsoft", 121),
      ("Logitech", 119),
      ("ZAGG", 119),
      ("Griffin Technology", 109),
      ("Belkin", 104),
    ].map { value, count in
      Facet(value: value, count: count)
    }
  }()
    
  static var previews: some View {
    NavigationView {
      let storage = FacetStorage(facets: test, selections: ["Samsung"])
      let _ = storage.onClick = { facet in
        storage.selections.formSymmetricDifference([facet.value])
      }
      FacetListView(facetStorage: storage)
    }
  }
  
}
