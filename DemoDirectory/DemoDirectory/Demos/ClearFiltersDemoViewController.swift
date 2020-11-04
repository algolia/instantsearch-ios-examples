//
//  ClearFiltersDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class ClearFiltersDemoViewController: UIViewController {

  let filterState: FilterState
  let searchStateViewController: SearchStateViewController

  let clearColorsConnector: FilterClearConnector
  let clearExceptColorsConnector: FilterClearConnector

  let clearColorsController: FilterClearButtonController
  let clearExceptColorsController: FilterClearButtonController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

    filterState = .init()
    searchStateViewController = .init()
    let groupColor = FilterGroup.ID.or(name: "color", filterType: .facet)

    clearColorsController = .init(button: .init())
    clearExceptColorsController = .init(button: .init())
    
    clearColorsConnector = .init(filterState: filterState,
                                 clearMode: .specified,
                                 filterGroupIDs: [groupColor],
                                 controller: clearColorsController)
    clearExceptColorsConnector = .init(filterState: filterState,
                                       clearMode: .except,
                                       filterGroupIDs: [groupColor],
                                       controller: clearExceptColorsController)

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

  func setup() {

    let categoryFacet = Filter.Facet(attribute: "category", value: "shoe")
    let redFacet = Filter.Facet(attribute: "color", value: "red")
    let greenFacet = Filter.Facet(attribute: "color", value: "green")
    
    filterState[and: "category"].add(categoryFacet)
    filterState[or: "color"].add(redFacet, greenFacet)
    filterState.notifyChange()
    
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.connectFilterState(filterState)

  }

  func setupUI() {
    view.backgroundColor = .white
    configureButton(clearColorsController.button, text: "Clear Colors")
    configureButton(clearExceptColorsController.button, text: "Clear Except Colors")
    configureLayout()
  }

  func configureButton(_ button: UIButton, text: String) {
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
    button.setTitleColor(.darkGray, for: .normal)
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.darkGray.cgColor
    button.layer.cornerRadius = 10
  }

  func configureLayout() {

    let mainStackView = UIStackView()
      .set(\.axis, to: .vertical)
      .set(\.alignment, to: .center)
      .set(\.spacing, to: .px16)
      .set(\.distribution, to: .fill)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
    
    mainStackView.addArrangedSubview(searchStateViewController.view)

    NSLayoutConstraint.activate([
      searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150),
      searchStateViewController.view.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.98)
    ])

    let buttonsStackView = UIStackView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.axis, to: .horizontal)
      .set(\.spacing, to: .px16)
      .set(\.distribution, to: .equalCentering)

    buttonsStackView.addArrangedSubview(clearColorsController.button)
    buttonsStackView.addArrangedSubview(clearExceptColorsController.button)
    
    mainStackView.addArrangedSubview(buttonsStackView)
    mainStackView.addArrangedSubview(.init())
    
    view.addSubview(mainStackView)
    mainStackView.pin(to: view.safeAreaLayoutGuide)

  }

}
