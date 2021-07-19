//
//  NumericRangeDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class FilterNumericRangeDemoViewController: UIViewController {

  let searcher: SingleIndexSearcher
  let filterState: FilterState
  
  let sliderConnector: NumberRangeConnector<Double>
  let duplicateSliderConnector: NumberRangeConnector<Double>

  let searchStateViewController: SearchStateViewController

  let numericRangeController: NumericRangeController
  let duplicateNumericRangeController: NumericRangeController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = SingleIndexSearcher(client: .demo, indexName: "mobile_demo_filter_numeric_comparison")
    self.filterState = .init()

    numericRangeController = NumericRangeController(rangeSlider: .init())
    
    sliderConnector = .init(searcher: searcher,
                             filterState: filterState,
                             attribute: "price",
                             controller: numericRangeController)

    duplicateNumericRangeController = NumericRangeController(rangeSlider: .init())
    
    duplicateSliderConnector = .init(searcher: searcher,
                             filterState: filterState,
                             attribute: "price",
                             controller: duplicateNumericRangeController)

    self.searchStateViewController = SearchStateViewController()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    searcher.connectFilterState(filterState)
    searchStateViewController.connectSearcher(searcher)
    searchStateViewController.connectFilterState(filterState)
    searcher.search()
  }

}


private extension FilterNumericRangeDemoViewController {

  func setupUI() {
    view.backgroundColor = .white
    let searchStateView = searchStateViewController.view!
    let mainStackView = UIStackView()
      .set(\.axis, to: .vertical)
      .set(\.spacing, to: .px16)
      .set(\.distribution, to: .fill)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.alignment, to: .center)
    mainStackView.addArrangedSubview(searchStateView)
    mainStackView.addArrangedSubview(numericRangeController.view)
    mainStackView.addArrangedSubview(duplicateNumericRangeController.view)
    mainStackView.addArrangedSubview(UIView().set(\.translatesAutoresizingMaskIntoConstraints, to: false))
    view.addSubview(mainStackView)
    mainStackView.pin(to: view.safeAreaLayoutGuide)
    searchStateView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    searchStateView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
  }

}

extension Double {
  /// Rounds the double to decimal places value
  func rounded(toPlaces places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
