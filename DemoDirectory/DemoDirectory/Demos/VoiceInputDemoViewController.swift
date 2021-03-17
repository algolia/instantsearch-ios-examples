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
  
  typealias HitType = Movie
  
  let searchTriggeringMode: SearchTriggeringMode
  
  let searcher: SingleIndexSearcher
  let voiceButton: UIButton
  let voiceOverlayController: VoiceOverlayController
  let queryInputConnector: QueryInputConnector
  
  let hitsInteractor: HitsInteractor<HitType>

  let searchBar: UISearchBar
  let textFieldController: TextFieldController
  let hitsTableViewController: MovieHitsTableViewController<HitType>
  
  init(searchTriggeringMode: SearchTriggeringMode) {
    self.searchBar = .init()
    self.searchTriggeringMode = searchTriggeringMode
    self.searcher = SingleIndexSearcher(client: .demo, indexName: "mobile_demo_movies")
    self.textFieldController = .init(searchBar: searchBar)
    self.queryInputConnector = QueryInputConnector(searcher: searcher,
                                                   searchTriggeringMode: .searchAsYouType,
                                                   controller: textFieldController)
    self.hitsInteractor = .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true)
    self.hitsTableViewController = MovieHitsTableViewController()
    voiceButton = .init()
    voiceOverlayController = .init()
    super.init(nibName: .none, bundle: .none)
    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  private func setup() {
    hitsTableViewController.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: hitsTableViewController.cellIdentifier)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableViewController)
    searcher.search()
  }
  
  @objc func didTapVoiceButton() {
    voiceOverlayController.start(on: self, textHandler: { (query, isFinal, _) in self.queryInputConnector.interactor.query = query }) { error in
      print(error)
    }
  }
  
}

private extension VoiceInputDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    voiceButton.translatesAutoresizingMaskIntoConstraints = false
    voiceButton.setTitle("Voice", for: .normal)
    voiceButton.setTitleColor(.black, for: .normal)
    voiceButton.addTarget(self, action: #selector(didTapVoiceButton), for: .touchUpInside)
    searchBar
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.searchBarStyle, to: .minimal)
    let searchStackView = UIStackView()
      .set(\.spacing, to: .px16)
      .set(\.axis, to: .horizontal)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
    searchStackView.addArrangedSubview(searchBar)
    searchStackView.addArrangedSubview(voiceButton)
    let stackView = UIStackView()
      .set(\.spacing, to: .px16)
      .set(\.axis, to: .vertical)
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
    stackView.addArrangedSubview(searchStackView)
    stackView.addArrangedSubview(hitsTableViewController.view)
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide)
  }
    
}
