//
//  SortByDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 04/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct SortByDemoSwiftUI: PreviewProvider {
  
  struct ContentView: View {
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var selectableSegmentObservableController: SelectableSegmentObservableController
    @ObservedObject var hitsController: HitsObservableController<Movie>
    
    @State var isEditing: Bool = false
    
    private func label(for indexName: IndexName) -> String {
      switch indexName {
      case "test_Bestbuy": return "Most relevant"
      case "test_Bestbuy_vr_price_asc": return "Relevant Sort - Lowest Price"
      case "test_Bestbuy_replica_price_asc": return "Hard Sort - Lowest Price"
      default: return ""
      }
    }
    
    var body: some View {
      VStack {
        SearchBar(text: $queryInputController.query,
                  isEditing: $isEditing)
          .padding(.all, 5)
        if #available(iOS 14.0, *) {
          Menu {
            let segmentTitles = selectableSegmentObservableController.segmentsTitles
            ForEach(0..<segmentTitles.count) { segmentIndex in
              Button(segmentTitles[segmentIndex]) {
                selectableSegmentObservableController.select(segmentIndex)
              }
            }
          } label: {
            if let selectedSegmentIndex = selectableSegmentObservableController.selectedSegmentIndex {
              Label(selectableSegmentObservableController.segmentsTitles[selectedSegmentIndex], systemImage: "arrow.up.arrow.down.circle")
            }
          }
        }
        HitsList(hitsController) { hit, index in
          VStack {
            HStack {
              hit.flatMap {
                Text("\($0.title) (\($0.year))")
              }
              Spacer()
            }
            Divider()
          }
          .padding(.horizontal, 5)
        }
      }
    }

  }
  
  static let demoController = SortByDemoController()
  static let queryInputController = QueryInputObservableController()
  static let selectableSegmentObservableController = SelectableSegmentObservableController()
  static let hitsController = HitsObservableController<Movie>()
  
  static func connect() {
    func title(for indexName: IndexName) -> String {
      switch indexName {
      case demoController.indexTitle:
        return "Default"
      case demoController.indexYearAsc:
        return "Year Asc"
      case demoController.indexYearDesc:
        return "Year Desc"
      default:
        return indexName.rawValue
      }
    }
    demoController.queryInputConnector.connectController(queryInputController)
    demoController.hitsConnector.connectController(hitsController)
    demoController.sortByConnector.connectController(selectableSegmentObservableController, presenter: { title(for: $0.name) })
  }

  
  static var previews: some View {
    ContentView(queryInputController: queryInputController,
                selectableSegmentObservableController: selectableSegmentObservableController,
                hitsController: hitsController).onAppear {
                  connect()
                }
  }
  

}
