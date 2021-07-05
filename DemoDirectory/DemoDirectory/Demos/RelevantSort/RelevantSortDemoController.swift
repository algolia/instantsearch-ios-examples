//
//  RelevantSortDemoController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 03/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch

class RelevantSortDemoController {

  struct Item: Codable {
    let name: String
  }
  
  let searcher: SingleIndexSearcher
  let queryInputConnector: QueryInputConnector
  let hitsConnector: HitsConnector<Item>
  let switchIndexInteractor: SwitchIndexInteractor
  let relevantSortConnector: RelevantSortConnector
  let statsConnector: StatsConnector
  
  init<SIC: SwitchIndexController, RSC: RelevantSortController, HC: HitsController, QIC: QueryInputController, SC: StatsTextController>(switchIndexController: SIC,
                                                                                                               relevantSortController: RSC,
                                                                                                               hitsController: HC,
                                                                                                               queryInputController: QIC,
                                                                                                               statsController: SC) where RSC.Item == RelevantSortConnector.TextualRepresentation?, HC.DataSource == HitsInteractor<Item> {
    let indices: [IndexName] = [
      "test_Bestbuy",
      "test_Bestbuy_vr_price_asc",
      "test_Bestbuy_replica_price_asc"
    ]
    self.searcher = .init(appID: "C7RIRJRYR9",
                          apiKey: "6861aeb4f69b81db206d49ddb9f1dc1e",
                          indexName: indices.first!)
    self.queryInputConnector = .init(searcher: searcher, controller: queryInputController)
    self.switchIndexInteractor = .init(indexNames: indices, selectedIndexName: indices.first!)
    self.relevantSortConnector = .init(searcher: searcher, controller: relevantSortController)
    self.hitsConnector = .init(searcher: searcher, controller: hitsController)
    self.statsConnector = .init(searcher: searcher, controller: statsController)
    switchIndexInteractor.connectSearcher(searcher)
    switchIndexInteractor.connectController(switchIndexController)
    searcher.search()
  }
  
}

import SwiftUI

class RelevantSortDemoViewController: UIViewController {
  
  let controller: RelevantSortDemoController
  let relevantSortController = RelevantSortObservableController()
  let switchIndexController = SwitchIndexObservableController()
  let hitsController = HitsObservableController<RelevantSortDemoController.Item>()
  let queryInputController = QueryInputObservableController()
  let statsController = StatsTextObservableController()
  
  init() {
    self.controller = .init(switchIndexController: switchIndexController,
                            relevantSortController: relevantSortController,
                            hitsController: hitsController,
                            queryInputController: queryInputController,
                            statsController: statsController)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let contentView = RelevantSortSwiftUIDemo.ContentView(queryInputController: queryInputController,
                                                          switchIndexController: switchIndexController,
                                                          relevantSortController: relevantSortController,
                                                          hitsController: hitsController,
                                                          statsController: statsController)
    let hostingController = UIHostingController(rootView: contentView)
    addChild(hostingController)
    hostingController.didMove(toParent: self)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(hostingController.view)
    hostingController.view.pin(to: view)
  }
  
}

struct RelevantSortSwiftUIDemo : PreviewProvider {
  
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
