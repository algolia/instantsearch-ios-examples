//
//  RatingViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 04/11/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class RatingViewController: UIViewController {
  
  let stackView = UIStackView()
  let valueLabel = UILabel()
  let stepper = UIStepper()
  let ratingController = NumericRatingController()
  
  var ratingControl: RatingControl {
    return ratingController.ratingControl
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupLayout()
  }
  
  func setupLayout() {
    ratingControl.translatesAutoresizingMaskIntoConstraints = false
    ratingControl.value = 3.5
    ratingControl.maximumValue = 5
    ratingControl.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)
    ratingControl.tintColor = .systemGreen

    stepper.translatesAutoresizingMaskIntoConstraints = false
    stepper.value = 3.5
    stepper.minimumValue = 0
    stepper.maximumValue = 5
    stepper.stepValue = 0.1
    stepper.addTarget(self, action: #selector(controlValueChanged), for: .valueChanged)

    valueLabel.font = .systemFont(ofSize: 20, weight: .heavy)
    valueLabel.translatesAutoresizingMaskIntoConstraints = false
    valueLabel.widthAnchor.constraint(equalToConstant: 44).isActive = true
    refreshLabel()

    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fill
    stackView.alignment = .top
    stackView.addArrangedSubview(ratingControl)
    stackView.addArrangedSubview(valueLabel)
    stackView.addArrangedSubview(stepper)
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  @objc private func controlValueChanged(_ sender: Any) {
    switch sender as? UIControl {
    case stepper:
      ratingControl.value = stepper.value
    case ratingControl:
      stepper.value = ratingControl.value
    default:
      break
    }
    refreshLabel()
  }
  
  private func refreshLabel() {
    valueLabel.text = fractionalString(for: ratingControl.value, fractionDigits: 1)
  }
  
  private func fractionalString(for value: Double, fractionDigits: Int) -> String {
    let formatter = NumberFormatter()
    formatter.minimumFractionDigits = fractionDigits
    formatter.maximumFractionDigits = fractionDigits
    return formatter.string(from: value as NSNumber) ?? "\(self)"
  }

  
}
