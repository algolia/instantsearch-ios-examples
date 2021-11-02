//
//  ViewController.swift
//  DemoAutocomplete
//
//  Created by Vladislav Fitc on 30/10/2021.
//

import UIKit
import InstantSearch
import SwiftUI

// QS
// QS with hits
// QS with categories
// QS with recent searches
// QS with recent searches and categories


class ViewController: UIViewController {

  func button(title: String) -> UIButton {
    let button = UIButton()
    button.setTitle(title, for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.borderColor = UIColor.black.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 5
    button.heightAnchor.constraint(equalToConstant: 44).isActive = true
    button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    return button
  }
  
  lazy var querySuggestionsButton: UIButton = button(title: "Query suggestions")
  lazy var facetHitsButton: UIButton = button(title: "Facets + Hits")
  lazy var multiHitsButton: UIButton = button(title: "MultiHits")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .equalCentering
    stackView.spacing = 10
    view.addSubview(stackView)
    additionalSafeAreaInsets = .init(top: 0, left: 7, bottom: 0, right: 7)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
    ])
    stackView.addArrangedSubview(UIView())
    stackView.addArrangedSubview(querySuggestionsButton)
    stackView.addArrangedSubview(facetHitsButton)
    stackView.addArrangedSubview(multiHitsButton)
    stackView.addArrangedSubview(UIView())
  }
  
  @objc func didTapButton(_ sender: UIButton) {
    let viewController: UIViewController
    switch sender {
    case querySuggestionsButton:
      viewController = QuerySuggestions.SearchViewController()
    case facetHitsButton:
      viewController = HitsAndFacetsSearchExample.SearchViewController()
    case multiHitsButton:
      viewController = MultiIndexSearchExample.SearchViewController()
    default:
      return
    }
    viewController.title = sender.title(for: .normal)
    navigationController?.pushViewController(viewController, animated: true)
  }


}

