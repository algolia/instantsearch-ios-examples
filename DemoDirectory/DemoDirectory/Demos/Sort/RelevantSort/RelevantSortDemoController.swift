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


