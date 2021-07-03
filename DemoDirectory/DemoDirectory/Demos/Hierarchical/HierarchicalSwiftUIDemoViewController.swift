//
//  HierarchicalSwiftUIDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 30/06/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import SwiftUI

class HierarchicalSwiftUIDemoViewController: UIViewController {
  
  let demoController: HierarchicalDemoController
  let controller: HierarchicalObservableController
  
  init() {
    self.controller = .init()
    self.demoController = .init(controller: controller)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let hostingController = UIHostingController(rootView: ContentView(controller: controller))
    addChild(hostingController)
    hostingController.didMove(toParent: self)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(hostingController.view)
    hostingController.view.pin(to: view)
  }
  
  struct ContentView: View {
    
    let controller: HierarchicalObservableController
    
    var body: some View {
      HStack {
        HierarchicalList(controller) { facet, nestingLevel, isSelected in
          HierarchicalFacetRow(facet: facet,
                               nestingLevel: nestingLevel,
                               isSelected: isSelected)
        }
        Spacer()
      }.padding()
    }
    
  }
  
}

struct HierarchicalListPreview: PreviewProvider {

  static var previews: some View {
    let demoController: HierarchicalObservableController = .init()
    HStack {
      HierarchicalList(demoController) { facet, nestingLevel, isSelected in
          HierarchicalFacetRow(facet: facet,
                               nestingLevel: nestingLevel,
                               isSelected: isSelected)
      }
      Spacer()
    }
    .padding()
    .onAppear {
      demoController.setItem([
        (Facet(value: "Category1", count: 10), 0, false),
        (Facet(value: "Category1 > Category1-1", count: 7), 1, false),
        (Facet(value: "Category1 > Category1-2", count: 2), 1, false),
        (Facet(value: "Category1 > Category1-3", count: 1), 1, false),
        (Facet(value: "Category2", count: 14), 0, true),
        (Facet(value: "Category2 > Category2-1", count: 8), 1, false),
        (Facet(value: "Category2 > Category2-2", count: 4), 1, true),
        (Facet(value: "Category2 > Category2-2 > Category2-2-1", count: 2), 2, false),
        (Facet(value: "Category2 > Category2-2 > Category2-2-2", count: 2), 2, true),
        (Facet(value: "Category2 > Category2-3", count: 2), 1, false)
      ])
    }
  }

}
