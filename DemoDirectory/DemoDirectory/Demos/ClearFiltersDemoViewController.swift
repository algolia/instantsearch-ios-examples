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

  let clearColorsInteractor: FilterClearInteractor
  let clearExceptColorsInteractor: FilterClearInteractor

  let clearColorsController: FilterClearButtonController
  let clearExceptColorsController: FilterClearButtonController

  let mainStackView = UIStackView()

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

    filterState = .init()
    searchStateViewController = .init()

    clearColorsInteractor = .init()
    clearExceptColorsInteractor = .init()

    clearColorsController = .init(button: .init())
    clearExceptColorsController = .init(button: .init())

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
    
    let groupColor = FilterGroup.ID.or(name: "color", filterType: .facet)

    clearColorsInteractor.connectFilterState(filterState, filterGroupIDs: [groupColor], clearMode: .specified)
    clearExceptColorsInteractor.connectFilterState(filterState, filterGroupIDs: [groupColor], clearMode: .except)

    clearColorsInteractor.connectController(clearColorsController)
    clearExceptColorsInteractor.connectController(clearExceptColorsController)

    searchStateViewController.connectFilterState(filterState)

  }

  func setupUI() {
    view.backgroundColor = .white
    configureButton(clearColorsController.button, text: "Clear Colors")
    configureButton(clearExceptColorsController.button, text: "Clear Except Colors")
    configureMainStackView()
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

  func configureMainStackView() {
    mainStackView.axis = .vertical
    mainStackView.alignment = .center
    mainStackView.spacing = .px16
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
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

    let buttonsStackView = UIStackView()
    buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
    buttonsStackView.axis = .horizontal
    buttonsStackView.spacing = .px16
    buttonsStackView.distribution = .equalCentering

    buttonsStackView.addArrangedSubview(clearColorsController.button)
    buttonsStackView.addArrangedSubview(clearExceptColorsController.button)
    
    mainStackView.addArrangedSubview(buttonsStackView)
    mainStackView.addArrangedSubview(.init())

  }

}
