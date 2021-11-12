//
//  FilterNumericComparisonDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 05/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class FilterNumericComparisonDemoViewController: UIViewController {

  let searcher: HitsSearcher
  let filterState: FilterState

  let yearConnector: FilterComparisonConnector<Int>
  let yearDuplicateConnector: FilterComparisonConnector<Int>
  let priceConnector: FilterComparisonConnector<Double>

  let searchStateViewController: SearchStateViewController

  let yearTextFieldController: NumericTextFieldController
  let duplicateYearTextFieldController: NumericTextFieldController
  let numericStepperController: NumericStepperController

  let stepperLabel = UILabel()

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = HitsSearcher(client: .demo, indexName: "mobile_demo_filter_numeric_comparison")
    self.filterState = .init()

    yearTextFieldController = NumericTextFieldController()
    duplicateYearTextFieldController = NumericTextFieldController()
    numericStepperController = NumericStepperController()
    
    self.yearConnector = .init(searcher: searcher,
                                      filterState: filterState,
                                      attribute: "year",
                                      numericOperator: .greaterThanOrEqual,
                                      number: 0,
                                      bounds: nil,
                                      operator: .and,
                                      controller: yearTextFieldController)
    
    self.yearDuplicateConnector = .init(searcher: searcher,
                                      filterState: filterState,
                                      attribute: "year",
                                      numericOperator: .greaterThanOrEqual,
                                      number: 0,
                                      bounds: nil,
                                      operator: .and,
                                      controller: duplicateYearTextFieldController)
    
    self.priceConnector = .init(searcher: searcher,
                                      filterState: filterState,
                                      attribute: "price",
                                      numericOperator: .greaterThanOrEqual,
                                      number: 0,
                                      bounds: nil,
                                      operator: .and,
                                      controller: numericStepperController)


    self.searchStateViewController = SearchStateViewController()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

private extension FilterNumericComparisonDemoViewController {

  func setup() {
    searcher.connectFilterState(filterState)
    searchStateViewController.connectSearcher(searcher)
    searchStateViewController.connectFilterState(filterState)
    searcher.search()
    stepperLabel.text = priceConnector.interactor.item.flatMap { "\($0)" }
  }

  func setupUI() {
    view.backgroundColor = .white
    
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    let yearInputContainer = UIView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.layer.borderWidth, to: 1)
      .set(\.layer.cornerRadius, to: 10)
      .set(\.layer.borderColor, to: UIColor.gray.cgColor)
    
    yearTextFieldController.textField.translatesAutoresizingMaskIntoConstraints = false
    yearTextFieldController.textField.keyboardType = .numberPad
    
    yearInputContainer.addSubview(yearTextFieldController.textField)
    yearTextFieldController.textField.pin(to: yearInputContainer, insets: .init(top: 0, left: 8, bottom: 0, right: 8))
    
    yearTextFieldController.textField.heightAnchor.constraint(equalToConstant: 40).isActive = true

    let duplicateYearInputContainer = UIView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.layer.borderWidth, to: 1)
      .set(\.layer.cornerRadius, to: 10)
      .set(\.layer.borderColor, to: UIColor.gray.cgColor)

    duplicateYearTextFieldController.textField.translatesAutoresizingMaskIntoConstraints = false
    duplicateYearTextFieldController.textField.keyboardType = .numberPad
    duplicateYearInputContainer.addSubview(duplicateYearTextFieldController.textField)
    duplicateYearTextFieldController.textField.pin(to: duplicateYearInputContainer, insets: .init(top: 0, left: 8, bottom: 0, right: 8))
    duplicateYearTextFieldController.textField.heightAnchor.constraint(equalToConstant: 40).isActive = true

    let stepperStackView = UIStackView()
      .set(\.axis, to: .horizontal)
      .set(\.spacing, to: .px16)
      .set(\.distribution, to: .fill)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.alignment, to: .center)
    stepperStackView.addArrangedSubview(numericStepperController.stepper)
    stepperStackView.addArrangedSubview(stepperLabel)
    numericStepperController.stepper.addTarget(self, action: #selector(onStepperValueChanged), for: .valueChanged)
    
    let mainStackView = UIStackView()
      .set(\.axis, to: .vertical)
      .set(\.spacing, to: .px16)
      .set(\.distribution, to: .fill)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.alignment, to: .center)
    
    mainStackView.addArrangedSubview(searchStateViewController.view)
    searchStateViewController.view.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 1).isActive = true
    
    mainStackView.addArrangedSubview(yearInputContainer)
    yearTextFieldController.textField.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.4).isActive = true
    
    mainStackView.addArrangedSubview(duplicateYearInputContainer)
    duplicateYearTextFieldController.textField.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.4).isActive = true

    mainStackView.addArrangedSubview(stepperStackView)
    mainStackView.addArrangedSubview(UIView().set(\.translatesAutoresizingMaskIntoConstraints, to: false))
    
    view.addSubview(mainStackView)
    
    mainStackView.pin(to: view.safeAreaLayoutGuide)
  }

  @objc func onStepperValueChanged(sender: UIStepper) {
    stepperLabel.text = priceConnector.interactor.item.flatMap { "\($0)" }
  }

}

extension UIView: Builder {}
