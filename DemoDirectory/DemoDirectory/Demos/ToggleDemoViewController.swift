//
//  ToggleDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 03/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class ToggleDemoViewController: UIViewController {
  
  let searcher: SingleIndexSearcher
  let filterState: FilterState
  let searchStateViewController: SearchStateViewController
  
  let sizeConstraintInteractor: SelectableInteractor<Filter.Numeric>
  let vintageInteractor: SelectableInteractor<Filter.Tag>
  let couponInteractor: SelectableInteractor<Filter.Facet>
  
  let mainStackView = UIStackView()
  let firstRowStackView = UIStackView()
  let secondRowStackView = UIStackView()
  let couponStackView = UIStackView()
  
  let vintageButtonController: SelectableFilterButtonController<Filter.Tag>
  let sizeConstraintButtonController: SelectableFilterButtonController<Filter.Numeric>
  let couponSwitchController: FilterSwitchController<Filter.Facet>
  
  let couponLabel = UILabel()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    
    searcher = SingleIndexSearcher(index: .demo(withName: "mobile_demo_filter_toggle"))
    filterState = .init()
    searchStateViewController = SearchStateViewController()
    
    // Size constraint button
    
    let sizeConstraintFilter = Filter.Numeric(attribute: "size", operator: .greaterThan, value: 40)
    sizeConstraintInteractor = SelectableInteractor(item: sizeConstraintFilter)
    sizeConstraintButtonController = SelectableFilterButtonController(button: .init())
    
    // Vintage tag button
    
    let vintageFilter = Filter.Tag(value: "vintage")
    vintageInteractor = SelectableInteractor(item: vintageFilter)
    vintageButtonController = SelectableFilterButtonController(button: .init())
    
    // Coupon switch
    
    let couponFacet = Filter.Facet(attribute: "promotions", stringValue: "coupon")
    couponInteractor = SelectableInteractor<Filter.Facet>(item: couponFacet)
    couponSwitchController = FilterSwitchController(switch: .init())
    
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


private extension ToggleDemoViewController {
  
  func setup() {
    searcher.connectFilterState(filterState)
    couponInteractor.connectFilterState(filterState, operator: .or)
    sizeConstraintInteractor.connectFilterState(filterState, operator: .or)
    vintageInteractor.connectFilterState(filterState, operator: .or)
    searchStateViewController.connectSearcher(searcher)
    searchStateViewController.connectFilterState(filterState)
    searcher.search()
    
    sizeConstraintInteractor.connectController(sizeConstraintButtonController)
    vintageInteractor.connectController(vintageButtonController)
    couponInteractor.connectController(couponSwitchController)
  }
  
  func setupUI() {
    view.backgroundColor = .white
    configureSizeButton()
    configureVintageButton()
    configureCouponLabel()
    configureCouponSwitch()
    configureCouponStackView()
    configureMainStackView()
    configureFirstRowStackView()
    configureSecondRowStackView()
    configureLayout()
  }
  
  func configureLayout() {
    
    view.addSubview(mainStackView)
    
    mainStackView.pin(to: view.safeAreaLayoutGuide)
    
    addChild(searchStateViewController)

    searchStateViewController.didMove(toParent: self)
    mainStackView.addArrangedSubview(searchStateViewController.view)
    
    NSLayoutConstraint.activate([
      searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150),
      searchStateViewController.view.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.98)
    ])
    
    sizeConstraintButtonController.button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    vintageButtonController.button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    couponStackView.addArrangedSubview(couponLabel)
    couponStackView.addArrangedSubview(couponSwitchController.switch)
    couponStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    firstRowStackView.addArrangedSubview(sizeConstraintButtonController.button)

    firstRowStackView.addArrangedSubview(self.spacer())
    firstRowStackView.addArrangedSubview(couponStackView)

    secondRowStackView.addArrangedSubview(vintageButtonController.button)
    secondRowStackView.addArrangedSubview(self.spacer())

    mainStackView.addArrangedSubview(firstRowStackView)
    mainStackView.addArrangedSubview(secondRowStackView)
    mainStackView.addArrangedSubview(self.spacer())
    
    firstRowStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.9).isActive = true
    secondRowStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.9).isActive = true
    
  }
  
  private func spacer() -> UIView {
    let view = UIView()
    view.setContentHuggingPriority(.defaultLow, for: .horizontal)
    return view
  }
  
  func configureMainStackView() {
    mainStackView.axis = .vertical
    mainStackView.alignment = .center
    mainStackView.spacing = .px16
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureFirstRowStackView() {
    firstRowStackView.axis = .horizontal
    firstRowStackView.distribution = .fill
    firstRowStackView.spacing = .px16
    firstRowStackView.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureSecondRowStackView() {
    secondRowStackView.axis = .horizontal
    secondRowStackView.distribution = .fill
    secondRowStackView.spacing = .px16
    secondRowStackView.translatesAutoresizingMaskIntoConstraints = false
  }

  func configureCheckBoxButton(_ button: UIButton, withTitle title: String) {
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(title, for: .normal)
    button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
    button.setTitleColor(.black, for: .normal)
    button.setImage(UIImage(named: "square"), for: .normal)
    button.setImage(UIImage(named: "check-square"), for: .selected)
  }
  
  func configureSizeButton() {
    configureCheckBoxButton(sizeConstraintButtonController.button, withTitle: "size > 40")
  }
  
  func configureVintageButton() {
    configureCheckBoxButton(vintageButtonController.button, withTitle: "vintage")
  }
  
  func configureCouponSwitch() {
    couponSwitchController.switch.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureCouponLabel() {
    couponLabel.text = "Coupon"
    couponLabel.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureCouponStackView() {
    couponStackView.translatesAutoresizingMaskIntoConstraints = false
    couponStackView.axis = .horizontal
    couponStackView.spacing = .px16
    couponStackView.alignment = .center
    couponStackView.distribution = .fill
  }
  
}

