//
//  VoiceInputDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 13/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch
import InstantSearchVoiceOverlay

class VoiceInputDemoViewController: UIViewController {
  
  let searchBar: UISearchBar = .init()
  let voiceInputButton: UIButton = .init()

  lazy var textFieldController: TextFieldController = .init(searchBar: searchBar)
  lazy var searchConnector: SingleIndexSearchConnector<BestBuyItem> = .init(appID: "latency",
                                                                            apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                                                            indexName: "bestbuy",
                                                                            queryInputController: textFieldController,
                                                                            hitsController: hitsTableViewController)
  let hitsTableViewController: BestBuyHitsViewController = .init()
  let voiceOverlayController: VoiceOverlayController = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchConnector.connect()
    searchConnector.hitsConnector.searcher.search()
    setupUI()
  }
  
  func setupUI() {
    view.backgroundColor = .white
    
    // Setup search bar
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
    
    // Setup voice input button
    voiceInputButton.translatesAutoresizingMaskIntoConstraints = false
    voiceInputButton.setImage(UIImage(systemName: "mic"), for: .normal)
    voiceInputButton.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 10)
    voiceInputButton.addTarget(self, action: #selector(didTapVoiceInputButton), for: .touchUpInside)

    // Setup layout
    let headerStackView = UIStackView()
    headerStackView.translatesAutoresizingMaskIntoConstraints = false
    headerStackView.addArrangedSubview(searchBar)
    headerStackView.addArrangedSubview(voiceInputButton)

    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    view.addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    stackView.addArrangedSubview(headerStackView)
    stackView.addArrangedSubview(hitsTableViewController.view)
  }
  
  @objc func didTapVoiceInputButton() {
    voiceOverlayController.start(on: self) { [weak self] (text, isFinal, _) in
      self?.searchConnector.queryInputConnector.interactor.query = text
    } errorHandler: { error in
      guard let error = error else { return }
      let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
      alertController.addAction(.init(title: "OK", style: .cancel, handler: .none))
      DispatchQueue.main.async { [weak self] in
        self?.present(alertController, animated: true, completion: nil)
      }
    }
  }
  
}
