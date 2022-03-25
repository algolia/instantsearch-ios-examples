//
//  RelevantSortDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class RelevantSortDemoViewController: UIViewController {
  
  let searchBar: UISearchBar
  let controller: RelevantSortDemoController
  let hitsController: RelevantHitsController
  let textFieldController: TextFieldController
  let relevantSortController: RelevantSortToggleController
  let sortByController: SortByController
  let statsController: LabelStatsController
  
  init() {
    self.searchBar = UISearchBar()
    self.hitsController = .init()
    self.textFieldController = .init(searchBar: searchBar)
    self.relevantSortController = .init()
    self.sortByController = .init(searchBar: searchBar)
    self.statsController = .init(label: .init())
    self.controller = .init(sortByController: sortByController,
                            relevantSortController: relevantSortController,
                            hitsController: hitsController,
                            queryInputController: textFieldController,
                            statsController: statsController)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    view.backgroundColor = .white
    searchBar.showsScopeBar = true
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(relevantSortController.view)
    stackView.addArrangedSubview(statsController.label)
    stackView.addArrangedSubview(hitsController.view)
  }
  
}

class SortByController: NSObject, SelectableSegmentController {
  
  let searchBar: UISearchBar
  
  var onClick: ((Int) -> Void)?
  
  init(searchBar: UISearchBar) {
    self.searchBar = searchBar
    super.init()
    self.searchBar.delegate = self
  }
  
  func setSelected(_ selected: Int?) {
    searchBar.selectedScopeButtonIndex = selected ?? 0
  }
  
  func setItems(items: [Int: String]) {
    searchBar.scopeButtonTitles = items.sorted(by: \.key).map(\.value)
  }

}

extension SortByController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    onClick?(selectedScope)
  }
  
}

class RelevantSortToggleController: UIViewController, RelevantSortController {
  
  var didToggle: (() -> Void)?
  
  let label: UILabel
  let button: UIButton
  
  init() {
    self.label = .init()
    self.button = .init()
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    layout()
  }
  
  func layout() {
    label.numberOfLines = 2
    label.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(.blue, for: .normal)
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(label)
    stackView.addArrangedSubview(button)
    view.addSubview(stackView)
    stackView.pin(to: view, insets: .init(top: 5, left: 5, bottom: -5, right: -5))
  }

  func setItem(_ item: RelevantSortTextualRepresentation?) {
    guard let item = item else {
      label.text = nil
      button.setTitle(nil, for: .normal)
      view.isHidden = true
      return
    }
    view.isHidden = false
    label.text = item.hintText
    button.setTitle(item.toggleTitle, for: .normal)
  }
  
  @objc func didTapButton() {
    didToggle?()
  }
  
}


class RelevantHitsController: UITableViewController, HitsController {
  
  var hitsSource: HitsInteractor<RelevantSortDemoController.Item>?
  
  let cellID = "cellID"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
    cell.textLabel?.text = hitsSource?.hit(atIndex: indexPath.row)?.name
    return cell
  }
  
}
