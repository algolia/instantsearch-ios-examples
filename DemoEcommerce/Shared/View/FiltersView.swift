//
//  ContentView.swift
//  Shared
//
//  Created by Vladislav Fitc on 10/04/2021.
//

import SwiftUI
import InstantSearch
import Sliders

struct FiltersView: View {
    
  @ObservedObject var facetSearchQueryInputController: QueryInputObservableController
  @ObservedObject var facetListController: FacetListObservableController
  @ObservedObject var filterClearController: FilterClearObservableController
  @ObservedObject var categoryHierarchicalController: HierarchicalObservableController
  @ObservedObject var freeShippingToggleController: FilterToggleObservableController<Filter.Facet>
  @ObservedObject var ratingController: RatingController
  @ObservedObject var priceRangeController: RangeController
  @ObservedObject var statsController: StatsObservableController
  @ObservedObject var currentFiltersController: CurrentFiltersObservableController
    
  // State
  @State private var isPresentingFacets = false
  @State private var isEditing = false
  
  @Environment(\.presentationMode) var presentation
  
  init(facetSearchQueryInputController: QueryInputObservableController,
       facetListController: FacetListObservableController,
       filterClearController: FilterClearObservableController,
       categoryHierarchicalController: HierarchicalObservableController,
       freeShippingToggleController: FilterToggleObservableController<Filter.Facet>,
       ratingController: RatingController,
       priceRangeController: RangeController,
       statsController: StatsObservableController,
       currentFiltersController: CurrentFiltersObservableController) {
    self.filterClearController = filterClearController
    self.facetSearchQueryInputController = facetSearchQueryInputController
    self.facetListController = facetListController
    self.categoryHierarchicalController = categoryHierarchicalController
    self.freeShippingToggleController = freeShippingToggleController
    self.ratingController = ratingController
    self.priceRangeController = priceRangeController
    self.statsController = statsController
    self.currentFiltersController = currentFiltersController
  }
  
  var body: some View {
    let stack =
      ScrollView {
        VStack(spacing: 20) {
          ExpandableView(title: "Category") {
            hierarchical()
          }
          ExpandableView(title: "Brand") {
            facets()
          }
          ExpandableView(title: "Free shipping") {
            toggle()
          }
          ExpandableView(title: "Rating") {
            rating()
          }
          ExpandableView(title: "Price") {
            priceRange()
          }
        }.padding(.vertical, 15)
      }
      .navigationTitle("Filters")
      .padding(.horizontal, 10)

    if UIDevice.current.userInterfaceIdiom == .phone {
      withToolbar(stack)
    } else {
      stack.navigationBarItems(trailing: clearFiltersButton())
    }
  }
  
  @ViewBuilder
  func withToolbar<V: View>(_ view: V) -> some View {
    view.toolbar {
      ToolbarItem(placement: .bottomBar) {
        Spacer()
      }
      ToolbarItem(placement: .bottomBar) {
        Text(statsController.stats)
      }
      ToolbarItem(placement: .bottomBar) {
        Spacer()
      }
      ToolbarItem(placement: .bottomBar) {
        clearFiltersButton()
      }
    }
  }
  
  func hierarchical() -> some View {
    HierarchicalList(hierarchicalController: categoryHierarchicalController)
  }
  
  func toggle() -> some View {
    Toggle(isOn: $freeShippingToggleController.isSelected) {
      Text("Display only items with free shipping")
    }
  }
  
  func rating() -> some View {
    RatingPicker(ratingController: ratingController)
  }
  
  @ViewBuilder
  func facets() -> some View {
    SearchableFacetList(facetSearchQueryInputController: facetSearchQueryInputController,
                        facetListController: facetListController)
  }
  
  func priceRange() -> some View {
    VStack {
      HStack {
        Text("$\(Int(priceRangeController.range.lowerBound))")
        Spacer()
        Text("$\(Int(priceRangeController.range.upperBound))")
      }
      RangeSlider(range: $priceRangeController.range,
                  in: priceRangeController.bounds,
                  step: 1)
        .frame(height: 40)
    }
  }
  
  func clearFiltersButton() -> some View {
    Button(action: filterClearController.clear,
           label: { Image(systemName: "arrow.uturn.backward.circle") }
    ).disabled(currentFiltersController.filters.isEmpty)
  }

}

extension FiltersView {
  
  init(viewModel: AlgoliaViewModel) {
    self.init(facetSearchQueryInputController: viewModel.facetSearchQueryInputController,
              facetListController: viewModel.facetListController,
              filterClearController: viewModel.filterClearController,
              categoryHierarchicalController: viewModel.categoryHierarchicalController,
              freeShippingToggleController: viewModel.freeShippingToggleController,
              ratingController: viewModel.ratingController,
              priceRangeController: viewModel.priceRangeController,
              statsController: viewModel.statsController,
              currentFiltersController: viewModel.currentFiltersController)
  }
  
}

struct FiltersView_Previews : PreviewProvider {
  
  static let algoliaController = AlgoliaController.test()
  
  static var previews: some View {
    FiltersView(viewModel: algoliaController.viewModel)
      .accentColor(.orange)
  }
}


