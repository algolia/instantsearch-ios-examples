//
//  RelevantSortDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import UIKit
import SwiftUI

class RelevantSortDemoViewController: UIViewController {
  
  let controller: RelevantSortDemoController
  let relevantSortController = RelevantSortObservableController()
  let sortByController = SelectableSegmentObservableController()
  let hitsController = HitsObservableController<RelevantSortDemoController.Item>()
  let queryInputController = QueryInputObservableController()
  let statsController = StatsTextObservableController()
  
  init() {
    self.controller = .init(sortByController: sortByController,
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
    let contentView = RelevantSortDemoSwiftUI.ContentView(queryInputController: queryInputController,
                                                          sortByController: sortByController,
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
