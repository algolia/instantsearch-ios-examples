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

  let controller: FilterNumericRangeDemoController

  let searchStateViewController: SearchStateViewController
  
  let primaryNumericRangeController: NumericRangeController
  let secondaryNumericRangeController: NumericRangeController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

    primaryNumericRangeController = NumericRangeController(rangeSlider: .init())
    secondaryNumericRangeController = NumericRangeController(rangeSlider: .init())
    
    self.controller = .init(primaryController: primaryNumericRangeController,
                            secondaryController: secondaryNumericRangeController)
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
    searchStateViewController.connectSearcher(controller.searcher)
    searchStateViewController.connectFilterState(controller.filterState)
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
    mainStackView.addArrangedSubview(primaryNumericRangeController.view)
    mainStackView.addArrangedSubview(secondaryNumericRangeController.view)
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

