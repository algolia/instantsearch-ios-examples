//
//  MainView.swift
//  DemoEcommerce
//
//  Created by Vladislav Fitc on 21/04/2021.
//

import Foundation
import SwiftUI
import InstantSearch
import InstantSearchSwiftUI

struct MainView: View {
  
  var algoliaViewModel: AlgoliaViewModel

  @ObservedObject var currentFiltersController: CurrentFiltersObservableController
  
  @State private var isFiltersViewPresented = false

  @Environment(\.presentationMode) var presentation

  var body: some View {
    let searchView = SearchView(viewModel: algoliaViewModel)
    let filtersView = FiltersView(viewModel: algoliaViewModel)
    NavigationView {
      if UIDevice.current.userInterfaceIdiom == .phone {
        searchView
          .navigationBarItems(trailing: filtersButton())
          .sheet(isPresented: $isFiltersViewPresented) {
            NavigationView {
              filtersView
            }
          }
      } else {
        filtersView
        searchView
      }
    }
  }
  
  private func filtersButton() -> some View {
    Button(action: {
      withAnimation {
        isFiltersViewPresented.toggle()
      }
    },
    label: {
      let imageName = currentFiltersController.filters.isEmpty ? "line.horizontal.3.decrease.circle" : "line.horizontal.3.decrease.circle.fill"
      Image(systemName: imageName)
        .font(.title)
    })
  }
  
  init(viewModel: AlgoliaViewModel) {
    self.algoliaViewModel = viewModel
    self.currentFiltersController = algoliaViewModel.currentFiltersController
  }
  
}


struct MainView_Previews : PreviewProvider {
  
  static let algoliaController = AlgoliaController.test()
    
  static var previews: some View {
    MainView(viewModel: algoliaController.viewModel)
  }
  
}
