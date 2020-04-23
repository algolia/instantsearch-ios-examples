//
//  RelatedItemsDemoViewController.swift
//  DemoDirectory
//
//  Created by test test on 20/04/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import UIKit
import InstantSearchCore
import InstantSearch
import SDWebImage

public struct MatchingPattern<Model> {
  let attribute: Attribute
  let score: Int
  let oneOrManyKeyPath: OneOrManyKeyPaths<Model, String>
  
  public init(attribute: Attribute, score: Int, filterPath: KeyPath<Model, String>) {
    self.attribute = attribute
    self.score = score
    self.oneOrManyKeyPath = .one(filterPath)
  }
  
  public init(attribute: Attribute, score: Int, filterPath: KeyPath<Model, [String]>) {
    self.attribute = attribute
    self.score = score
    self.oneOrManyKeyPath = .many(filterPath)
  }
  
  enum OneOrManyKeyPaths<T, V> {
    case one(KeyPath<T, V>)
    case many(KeyPath<T, [V]>)
  }
}

class RelatedItemsDemoViewController: UIViewController {
  
  let stackView = UIStackView()
  
  let searcher: SingleIndexSearcher
  let hitsInteractor: HitsInteractor<Hit<Product>>
  let hitsTableViewController: EcommerceHitsTableViewController
  
  let relatedItemSearcher: SingleIndexSearcher
  let relatedHitsInteractor: HitsInteractor<Hit<Product>>
  let relatedHitsTableViewController: EcommerceHitsTableViewController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = SingleIndexSearcher(index: .demo(withName: "instant_search"))
    self.hitsInteractor = .init(settings: .init(infiniteScrolling: .off, showItemsOnEmptyQuery: true))
    self.hitsTableViewController = EcommerceHitsTableViewController()
    
    self.relatedItemSearcher = SingleIndexSearcher(index: .demo(withName: "instant_search"))
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
      
      self.relatedItemSearcher.indexQueryState.query.sumOrFiltersScores = true
      self.relatedItemSearcher.indexQueryState.query.facetFilters = ["objectID:-\(hit.objectID)"]
      
      let matchingPatterns: [MatchingPattern<Product>] =
        [
          MatchingPattern(attribute: "brand", score: 3, filterPath: \.brand),
          MatchingPattern(attribute: "type", score: 10, filterPath: \.type),
          MatchingPattern(attribute: "categories", score: 2, filterPath: \.categories),
        ]

      let filterState = FilterState()
      
      for matchingPattern in matchingPatterns {
        switch matchingPattern.oneOrManyKeyPath {
        case .one(let keyPath):
          let facetValue = hit.object[keyPath: keyPath]
          let facetFilter = Filter.Facet.init(attribute: matchingPattern.attribute, value: .string(facetValue), score: matchingPattern.score)
          filterState[and: matchingPattern.attribute.name].add(facetFilter)
        case .many(let keyPath):
          let facetFilters = hit.object[keyPath: keyPath].map { Filter.Facet.init(attribute: matchingPattern.attribute, value: .string($0), score: matchingPattern.score) }
          filterState[or: matchingPattern.attribute.name].addAll(facetFilters)
        }
      }
      
      let legacyFilters = FilterGroupConverter().legacy(filterState.toFilterGroups())
      
      // workaround as the client only accepts [Stirng] and not [[String]] for now...
      var reducedOptionalFilters: [String] = []
      if let legacyFilters = legacyFilters {
        
        for legacyFilter in legacyFilters {
          if legacyFilter.count == 1 {
            let string = legacyFilter.first!
            reducedOptionalFilters.append(string)
          } else if legacyFilter.count > 1 {
            let string = "[\(legacyFilter.joined(separator: ","))]"
            if let escapedString = string.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
              reducedOptionalFilters.append(escapedString)
            }
          }
        }
      }
      
      //print(optionalFilters)
      //print(FilterGroupConverter().sql(filterState.toFilterGroups()))
      print(reducedOptionalFilters)
      
//          self.relatedItemSearcher.indexQueryState.query.optionalFilters = ["brand:Amazon<score=3>","type:Streaming media plyr<score=10>","%5B%22categories%3ATV%20%26%20Home%20Theater%3Cscore%3D2%3E%22%2C%22categories%3AStreaming%20Media%20Players%3Cscore%3D2%3E%22%5D"]
      
//      self.relatedItemSearcher.indexQueryState.query.optionalFilters = ["brand:Amazon<score=3>","type:Streaming media plyr<score=10>","%5B%22categories%22%3A%22TV%20%26%20Home%20Theater%3Cscore%3D2%3E%22%2C%22categories%22%3A%22Streaming%20Media%20Players%3Cscore%3D2%3E%22%5D"]
      
      self.relatedItemSearcher.indexQueryState.query.optionalFilters = reducedOptionalFilters
      
      self.relatedItemSearcher.search()
    }
    

    
    searcher.indexQueryState.query.hitsPerPage = 3
    
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableViewController)
    
    // connectSearcher<T>(searcher: withRelatedItemsToHit andMatchingPatterns: )
    relatedHitsInteractor.connectSearcher(relatedItemSearcher)
    relatedHitsInteractor.connectController(relatedHitsTableViewController)
    
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
