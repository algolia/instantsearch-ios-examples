//
//  RelevantSortDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct RelevantSortDemoSwiftUI : PreviewProvider {
  
  struct ContentView: View {
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var switchIndexController: SwitchIndexObservableController
    @ObservedObject var relevantSortController: RelevantSortObservableController
    @ObservedObject var hitsController: HitsObservableController<RelevantSortDemoController.Item>
    @ObservedObject var statsController: StatsTextObservableController
    
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
        Text(statsController.stats)
        if let state = relevantSortController.state {
          HStack {
            Text(state.hintText)
              .foregroundColor(.gray)
              .font(.footnote)
            Spacer()
            Button(state.toggleTitle,
                   action: relevantSortController.toggle)
          }.padding(.all, 5)
        }
        HitsList(hitsController) { hit, index in
          VStack {
            HStack {
              Text(hit?.name ?? "")
              Spacer()
            }
            Divider()
          }
          .padding(.horizontal, 5)
        }
      }
    }

  }
  
  static let relevantSortController = RelevantSortObservableController()
  static let switchIndexController = SwitchIndexObservableController()
  static let hitsController = HitsObservableController<RelevantSortDemoController.Item>()
  static let queryInputController = QueryInputObservableController()
  static let statsController = StatsTextObservableController()
  
  static let demoController = RelevantSortDemoController(switchIndexController: switchIndexController,
                                                         relevantSortController: relevantSortController,
                                                         hitsController: hitsController,
                                                         queryInputController: queryInputController,
                                                         statsController: statsController)
  
  static var previews: some View {
    let _ = (demoController,
             relevantSortController,
             switchIndexController,
             queryInputController)
    ContentView(queryInputController: queryInputController,
                switchIndexController: switchIndexController,
                relevantSortController: relevantSortController,
                hitsController: hitsController,
                statsController: statsController)
  }
  

}
