//
//  RefinementListDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 03/05/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

extension UIColor {
  static let swBackground = UIColor(hexString: "#f7f8fa")
}

extension CGFloat {
  static let px16: CGFloat = 16
}

class RefinementListDemoViewController: UIViewController {
  
  let searcher: SingleIndexSearcher
  let filterState: FilterState
  let colorInteractor: FacetListInteractor
  let categoryInteractor: FacetListInteractor
  let promotionInteractor: FacetListInteractor

  let searchStateViewController: SearchStateViewController
  let colorController: FacetListTableController
  let categoryController: FacetListTableController
  let promotionController: FacetListTableController
  
  let colorAttribute = Attribute("color")
  let promotionAttribute = Attribute("promotions")
  let categoryAttribute = Attribute("category")
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    
    searcher = .init(index: .demo(withName:"mobile_demo_facet_list"))
    searchStateViewController = .init()
    filterState = .init()
    colorInteractor = .init(selectionMode: .single)
    promotionInteractor = .init(selectionMode: .multiple)
    categoryInteractor = .init(selectionMode: .multiple)
    
    let colorTitleDescriptor = TitleDescriptor(text: "And, IsRefined-AlphaAsc, I=3", color: .init(hexString: "#ffcc0000"))
    colorController = FacetListTableController(tableView: .init(), titleDescriptor: colorTitleDescriptor)
    
    let promotionTitleDescriptor = TitleDescriptor(text: "And, CountDesc, I=5", color: .init(hexString: "#ff669900"))
    promotionController = FacetListTableController(tableView: .init(), titleDescriptor: promotionTitleDescriptor)
    
    let categoryTitleDescriptor = TitleDescriptor(text: "Or, CountDesc-AlphaAsc, I=5", color: .init(hexString: "#ff0099cc"))
    categoryController = .init(tableView: .init(), titleDescriptor: categoryTitleDescriptor)
    
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

private extension RefinementListDemoViewController {
  
  func setup() {
    
    // Color
    colorInteractor.connectSearcher(searcher, with: colorAttribute)
    colorInteractor.connectFilterState(filterState, with: colorAttribute, operator: .and)
    let colorPresenter = FacetListPresenter(sortBy: [.isRefined, .alphabetical(order: .ascending)], limit: 3)
    colorInteractor.connectController(colorController, with: colorPresenter)

    // Promotion
    promotionInteractor.connectSearcher(searcher, with: promotionAttribute)
    promotionInteractor.connectFilterState(filterState, with: promotionAttribute, operator: .and)
    let promotionPresenter = FacetListPresenter(sortBy: [.count(order: .descending)], limit: 5)

    promotionInteractor.connectController(promotionController, with: promotionPresenter)

    // Category
    categoryInteractor.connectSearcher(searcher, with: categoryAttribute)
    categoryInteractor.connectFilterState(filterState, with: categoryAttribute, operator: .or)
    let categoryRefinementListPresenter = FacetListPresenter(sortBy: [.count(order: .descending), .alphabetical(order: .ascending)], showEmptyFacets: false)
    categoryInteractor.connectController(categoryController, with: categoryRefinementListPresenter)
    
    searchStateViewController.connectSearcher(searcher)
    searchStateViewController.connectFilterState(filterState)
    
    // Predefined filter
    let greenColor = Filter.Facet(attribute: colorAttribute, stringValue: "green")
    let groupID = FilterGroup.ID.and(name: colorAttribute.name)
    filterState.notify(.add(filter: greenColor, toGroupWithID: groupID))
    
    searcher.connectFilterState(filterState)
    searcher.search()
    
  }
  
}

extension RefinementListDemoViewController {
  
  func setupUI() {
    
    view.backgroundColor = .swBackground
    
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.distribution = .fill
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.spacing = .px16
    
    addChild(searchStateViewController)
    searchStateViewController.didMove(toParent: self)
    searchStateViewController.view.heightAnchor.constraint(equalToConstant: 150).isActive = true
    mainStackView.addArrangedSubview(searchStateViewController.view)
    
    let gridStackView = UIStackView()
    gridStackView.axis = .horizontal
    gridStackView.spacing = .px16
    gridStackView.distribution = .fillEqually
    
    gridStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let firstColumn = UIStackView()
    firstColumn.axis = .vertical
    firstColumn.spacing = .px16
    firstColumn.distribution = .fillEqually
    
    firstColumn.addArrangedSubview(colorController.tableView)
    firstColumn.addArrangedSubview(promotionController.tableView)
    
    gridStackView.addArrangedSubview(firstColumn)
    gridStackView.addArrangedSubview(categoryController.tableView)
    
    mainStackView.addArrangedSubview(gridStackView)
    
    view.addSubview(mainStackView)
    
    mainStackView.pin(to: view.safeAreaLayoutGuide)
    
    [
      colorController,
      promotionController,
      categoryController
    ]
      .map { $0.tableView }
      .forEach {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        $0.alwaysBounceVertical = false
        $0.tableFooterView = UIView(frame: .zero)
        $0.backgroundColor = .swBackground
    }
    
  }
  
}
