//
//  DemoEcommerceApp.swift
//  Shared
//
//  Created by Vladislav Fitc on 10/04/2021.
//

import SwiftUI

@main
struct DemoEcommerceApp: App {
  
  let algoliaController = AlgoliaController.test()
  
  var body: some Scene {
    WindowGroup {
      MainView(viewModel: algoliaController.viewModel)
    }
  }
  
}
