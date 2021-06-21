//
//  DynamicFacetsSwiftUIDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 16/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import SwiftUI

struct DynamicFacets: View {
  
  @ObservedObject var dynamicFacetsController: DynamicFacetsObservableController
    
  var body: some View {
    ScrollView {
      ForEach(dynamicFacetsController.orderedFacets, id: \.attribute) { orderedFacet in
        VStack(spacing: 0) {
          // Facet header
          ZStack {
            Color(.systemGray5)
            Text(orderedFacet.attribute.rawValue)
              .fontWeight(.semibold)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.horizontal, 5)
          }
          // Facet values
          ForEach(orderedFacet.facets, id: \.value) { facet in
            VStack(spacing: 0) {
              FacetRow(facet: facet,
                       isSelected: dynamicFacetsController.isSelected(facet, for: orderedFacet.attribute))
                .onTapGesture {
                  dynamicFacetsController.toggle(facet, for: orderedFacet.attribute)
                }
                .frame(minHeight: 44, idealHeight: 44, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal, 5)
            }
          }
        }
      }
    }
  }
  
}

class DynamicFacetsSwiftUIDemoViewController: UIHostingController<DynamicFacets> {
  
  let queryInputController: QueryInputObservableController
  let facetsController: DynamicFacetsObservableController
  let algoliaController: DynamicFacetsDemoController
  
  init() {
    queryInputController = .init()
    facetsController = .init()
    algoliaController = .init(queryInputController: queryInputController,
                              dynamicFacetsController: facetsController)
    super.init(rootView: DynamicFacets(dynamicFacetsController: facetsController))
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

struct DynamicFacets_Preview: PreviewProvider {
  
  static let queryInputController = QueryInputObservableController()
  static let facetsController = DynamicFacetsObservableController()
  static let controller = DynamicFacetsDemoController(queryInputController: queryInputController,
                                                      dynamicFacetsController: facetsController)
  
  static var previews: some View {
    DynamicFacets(dynamicFacetsController: facetsController)
  }
  
}
