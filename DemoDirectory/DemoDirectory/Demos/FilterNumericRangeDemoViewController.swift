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
import WARangeSlider

class FilterNumericRangeDemoViewController: UIViewController {

  let priceAttribute = Attribute("price")

  let searcher: SingleIndexSearcher
  let filterState: FilterState

  let sliderInteractor1: NumberRangeInteractor<Double>
  let sliderInteractor2: NumberRangeInteractor<Double>

  let searchStateViewController: SearchStateViewController

  let numericRangeController1: NumericRangeController
  let numericRangeController2: NumericRangeController

  let mainStackView = UIStackView(frame: .zero)
  let sliderStackView1 = UIStackView(frame: .zero)
  let sliderStackView2 = UIStackView(frame: .zero)
  let sliderLower1 = UILabel()
  let sliderUpper1 = UILabel()
  let sliderLower2 = UILabel()
  let sliderUpper2 = UILabel()

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = SingleIndexSearcher(index: .demo(withName:"mobile_demo_filter_numeric_comparison"))
    self.filterState = .init()

    sliderInteractor1 = .init()
    sliderInteractor2 = .init()

    let textField = UITextField()
    let textField2 = UITextField()
    textField.keyboardType = .numberPad
    textField2.keyboardType = .numberPad

    numericRangeController1 = NumericRangeController(rangeSlider: .init())
    numericRangeController2 = NumericRangeController(rangeSlider: .init())

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


private extension FilterNumericRangeDemoViewController {

  func setup() {

    searcher.connectFilterState(filterState)

    sliderInteractor1.connectFilterState(filterState, attribute: priceAttribute)
    sliderInteractor1.connectController(numericRangeController1)
    sliderInteractor1.connectSearcher(searcher, attribute: priceAttribute)

    sliderInteractor2.connectFilterState(filterState, attribute: priceAttribute)
    sliderInteractor2.connectController(numericRangeController2)
    sliderInteractor2.connectSearcher(searcher, attribute: priceAttribute)

    searchStateViewController.connectSearcher(searcher)
    searchStateViewController.connectFilterState(filterState)

    searcher.search()
  }

  func setupUI() {
    view.backgroundColor = .white
    configureMainStackView()

    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true

    mainStackView.addArrangedSubview(searchStateViewController.view)
    searchStateViewController.view.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 1).isActive = true

    configureHorizontalStackView(sliderStackView1)
    configureHorizontalStackView(sliderStackView2)

    sliderLower1.widthAnchor.constraint(equalToConstant: 50).isActive = true
    sliderLower2.widthAnchor.constraint(equalToConstant: 50).isActive = true
    sliderUpper1.widthAnchor.constraint(equalToConstant: 50).isActive = true
    sliderUpper2.widthAnchor.constraint(equalToConstant: 50).isActive = true

    numericRangeController1.rangerSlider.heightAnchor.constraint(equalToConstant: 50).isActive = true
    numericRangeController1.rangerSlider.widthAnchor.constraint(equalToConstant: 500).isActive = true
    sliderStackView1.addArrangedSubview(sliderLower1)
    sliderStackView1.addArrangedSubview(numericRangeController1.rangerSlider)
    sliderStackView1.addArrangedSubview(sliderUpper1)
    sliderInteractor1.onItemChanged.subscribePast(with: self) { viewController, range in
      guard let range = range else { return }
      viewController.sliderLower1.text = "\(range.lowerBound.rounded(toPlaces: 2))"
      viewController.sliderUpper1.text = "\(range.upperBound.rounded(toPlaces: 2))"
    }

    sliderStackView1.heightAnchor.constraint(equalToConstant: 50).isActive = true
    mainStackView.addArrangedSubview(sliderStackView1)

    numericRangeController2.rangerSlider.heightAnchor.constraint(equalToConstant: 50).isActive = true
    numericRangeController2.rangerSlider.widthAnchor.constraint(equalToConstant: 500).isActive = true
    sliderStackView2.addArrangedSubview(sliderLower2)
    sliderStackView2.addArrangedSubview(numericRangeController2.rangerSlider)
    sliderStackView2.addArrangedSubview(sliderUpper2)
    sliderInteractor2.onItemChanged.subscribePast(with: self) { viewController, range in
      guard let range = range else { return }
      viewController.sliderLower2.text = "\(range.lowerBound.rounded(toPlaces: 2))"
      viewController.sliderUpper2.text = "\(range.upperBound.rounded(toPlaces: 2))"
    }
    mainStackView.addArrangedSubview(sliderStackView2)

    let spacerView = UIView()
    spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
    mainStackView.addArrangedSubview(spacerView)

    view.addSubview(mainStackView)

    mainStackView.pin(to: view.safeAreaLayoutGuide)
    
  }

  @objc func onSlider1ValueChanged(sender: RangeSlider) {

  }

  @objc func onSlider2ValueChanged(sender: RangeSlider) {
    sliderLower2.text = "\(sender.lowerValue.rounded(toPlaces: 2))"
    sliderUpper2.text = "\(sender.upperValue.rounded(toPlaces: 2))"
  }

  func configureMainStackView() {
    mainStackView.axis = .vertical
    mainStackView.spacing = .px16
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.alignment = .center
  }

  func configureHorizontalStackView(_ stackView: UIStackView) {
    stackView.axis = .horizontal
    stackView.spacing = .px16
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .center
    
  }

}

extension Double {
  /// Rounds the double to decimal places value
  func rounded(toPlaces places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}
