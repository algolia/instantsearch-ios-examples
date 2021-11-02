//
//  QuerySuggestions.swift
//  DemoAutocomplete
//
//  Created by Vladislav Fitc on 30/10/2021.
//

import Foundation
import InstantSearch
import UIKit

enum QuerySuggestions {
  
  class SearchViewController: UIViewController {
    
    let searchController: UISearchController
    
    let queryInputConnector: QueryInputConnector
    let textFieldController: TextFieldController

    let hitsSearcher: HitsSearcher
    let hitsInteractor: HitsInteractor<QuerySuggestion>
    
    let searchResultsController: SearchResultsController
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      hitsSearcher = .init(appID: "latency",
                           apiKey: "afc3dd66dd1293e2e2736a5a51b05c0a",
                           indexName: "instantsearch_query_suggestions")
      searchResultsController = .init()
      hitsInteractor = .init()
      searchController = .init(searchResultsController: searchResultsController)
      textFieldController = .init(searchBar: searchController.searchBar)
      queryInputConnector = .init(searcher: hitsSearcher,
                                  controller: textFieldController)
      hitsInteractor.connectSearcher(hitsSearcher)
      hitsInteractor.connectController(searchResultsController)
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      searchResultsController.onTypeAhead = { [weak self] in
        self?.queryInputConnector.interactor.query = $0
      }
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
      hitsSearcher.search()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      searchController.isActive = true
    }
    
    func configureUI() {
      view.backgroundColor = .white
      searchController.hidesNavigationBarDuringPresentation = false
      searchController.showsSearchResultsController = true
      searchController.automaticallyShowsCancelButton = false
      navigationItem.searchController = searchController
    }
    
  }

  class SearchResultsController: UITableViewController, HitsController {
        
    var hitsSource: HitsInteractor<QuerySuggestion>?
    
    var onTypeAhead: ((String) -> Void)?
    
    private func typeAheadButton() -> UIButton {
      let typeAheadButton = UIButton()
      typeAheadButton.setImage(UIImage(systemName: "arrow.up.left"), for: .normal)
      typeAheadButton.sizeToFit()
      typeAheadButton.addTarget(self, action: #selector(didTapTypeAheadButton), for: .touchUpInside)
      return typeAheadButton
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      hitsSource?.numberOfHits() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
      cell.textLabel?.attributedText = hitsSource?
        .hit(atIndex: indexPath.row)?
        .highlighted
        .flatMap(HighlightedString.init)
        .flatMap { NSAttributedString(highlightedString: $0,
                                      inverted: true,
                                      attributes: [.font: UIFont.boldSystemFont(ofSize: cell.textLabel!.font.pointSize)])
      }
      let typeAheadButton = (cell.accessoryView as? UIButton) ?? typeAheadButton()
      typeAheadButton.tag = indexPath.row
      cell.accessoryView = typeAheadButton
      return cell
    }
    
    @objc func didTapTypeAheadButton(_ sender: UIButton) {
      hitsSource?.hit(atIndex: sender.tag).flatMap {
        onTypeAhead?($0.query)
      }
    }
        
  }

}
