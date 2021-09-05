//
//  RelatedItemsDemoViewController.swift
//  DemoDirectory
//
//  Created by test test on 20/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import UIKit
import InstantSearch
import SDWebImage

class RelatedItemsDemoViewController: UIViewController {
  
  let stackView = UIStackView()
  
  let searcher: HitsSearcher
  let hitsInteractor: HitsInteractor<Hit<Product>>
  let hitsTableViewController: EcommerceHitsTableViewController
  
  let relatedItemSearcher: HitsSearcher
  let relatedHitsInteractor: HitsInteractor<Hit<Product>>
  let relatedHitsTableViewController: EcommerceHitsTableViewController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = HitsSearcher(client: .demo, indexName: "instant_search")
    self.hitsInteractor = .init(settings: .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true))
    self.hitsTableViewController = EcommerceHitsTableViewController()
    self.relatedItemSearcher = HitsSearcher(client: .demo, indexName: "instant_search")
    self.relatedHitsInteractor = .init()
    self.relatedHitsTableViewController = EcommerceHitsTableViewController()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
    
    hitsTableViewController.tableView.keyboardDismissMode = .onDrag
    hitsTableViewController.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: hitsTableViewController.cellIdentifier)
    
    relatedHitsTableViewController.tableView.keyboardDismissMode = .onDrag
    relatedHitsTableViewController.cellIdentifier = "relatedCellID"
    relatedHitsTableViewController.tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: relatedHitsTableViewController.cellIdentifier)
    
    hitsTableViewController.didSelect = { hit in
      
      
      let matchingPatterns: [MatchingPattern<Product>] =
        [
          MatchingPattern(attribute: "brand", score: 3, filterPath: \.brand),
          MatchingPattern(attribute: "type", score: 10, filterPath: \.type),
          MatchingPattern(attribute: "categories", score: 2, filterPath: \.categories),
        ]
      let objectWrapper = ObjectWrapper(objectID: hit.objectID, object: hit.object)
      self.relatedHitsInteractor.connectSearcher(self.relatedItemSearcher, withRelatedItemsTo: objectWrapper, with: matchingPatterns)
      self.relatedHitsInteractor.connectController(self.relatedHitsTableViewController)
      
      self.relatedItemSearcher.search()
    }
    

    
    searcher.indexQueryState.query.hitsPerPage = 3
    
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableViewController)
    
    searcher.search()
  }

}

private extension RelatedItemsDemoViewController {
  
  func configureUI() {
    title = "Related Items"
    view.backgroundColor = .white
    configureStackView()
    configureLayout()
  }
  
  
  func configureStackView() {
    stackView.spacing = .px16
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureLayout() {
    
//    addChild(hitsTableViewController)
//    hitsTableViewController.didMove(toParent: self)
    
    let label = UILabel()
    label.text = "    Related Items"
    label.font = .boldSystemFont(ofSize: 18)
    label.translatesAutoresizingMaskIntoConstraints = false
    
    hitsTableViewController.tableView.alwaysBounceVertical = false
    
    stackView.addArrangedSubview(hitsTableViewController.view)
    stackView.addArrangedSubview(label)
    stackView.addArrangedSubview(relatedHitsTableViewController.view)
    
    hitsTableViewController.view.heightAnchor.constraint(equalToConstant: 250).isActive = true
    
    
    view.addSubview(stackView)

    stackView.pin(to: view.safeAreaLayoutGuide)

  }
  
}
