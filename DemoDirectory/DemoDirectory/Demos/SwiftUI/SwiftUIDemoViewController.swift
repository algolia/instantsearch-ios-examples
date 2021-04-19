//
//  SwiftUIDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 25/03/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import SwiftUI

class SwiftUIDemoViewController: UIHostingController<ContentView> {
  
  let viewModel = AlgoliaController.test(areFacetsSearchable: true)
  
  init() {
    let contentView = ContentView(areFacetsSearchable: true)
    super.init(rootView: contentView)
    viewModel.setup(contentView)
    UIScrollView.appearance().keyboardDismissMode = .interactive
  }
  
  @objc required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

struct ContentView_Previews : PreviewProvider {
  
  static let viewModel = AlgoliaController.test(areFacetsSearchable: true)
  
  static var previews: some View {
    let contentView = ContentView(areFacetsSearchable: viewModel.areFacetsSearchable)
    let _ = viewModel.setup(contentView)
    NavigationView {
      contentView
    }
  }
  
}
