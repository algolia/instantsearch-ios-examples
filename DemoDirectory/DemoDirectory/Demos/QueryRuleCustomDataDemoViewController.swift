//
//  QueryRuleCustomDataDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 12/10/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import SDWebImage
import QuerySuggestions

class QueryRuleCustomDataDemoViewController: UIViewController {
  
  typealias HitType = ShopItem
  
  let stackView = UIStackView()
  let searchBar = UISearchBar()
  
  let searcher: SingleIndexSearcher
  
  let queryInputInteractor: QueryInputInteractor
  let textFieldController: TextFieldController
  
  let statsInteractor: StatsInteractor
  let statsController: LabelStatsController
  
  let hitsInteractor: HitsInteractor<HitType>
  let hitsTableViewController: ResultsTableViewController
  
  let queryRuleCustomDataConnector: QueryRuleCustomDataConnector<Banner>
  let bannerViewController: BannerViewController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = SingleIndexSearcher(client: .demo, indexName: "instant_search")
    self.queryInputInteractor = .init()
    self.textFieldController = .init(searchBar: searchBar)
    self.statsInteractor = .init()
    self.statsController = .init(label: .init())
    self.hitsInteractor = .init(infiniteScrolling: .on(withOffset: 5), showItemsOnEmptyQuery: true)
    self.hitsTableViewController = ResultsTableViewController()
    self.bannerViewController = BannerViewController()
    self.queryRuleCustomDataConnector = .init(searcher: searcher, controller: bannerViewController)
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

    queryInputInteractor.connectSearcher(searcher, searchTriggeringMode: .searchAsYouType)
    queryInputInteractor.connectController(textFieldController)
    
    statsInteractor.connectSearcher(searcher)
    statsInteractor.connectController(statsController)
    
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsTableViewController)
    
    bannerViewController.didTapBanner = { [weak self] in
      if let link = self?.bannerViewController.banner?.link {
        switch link.absoluteString {
        case "algoliademo://discounts":
          let submitViewController = TemplateViewController()
          submitViewController.label.textAlignment = .center
          submitViewController.label.text = "Redirect via banner tap"
          self?.present(UINavigationController(rootViewController: submitViewController), animated: true, completion: nil)
        default:
          UIApplication.shared.open(link)
        }
      }
    }
    
    queryInputInteractor.onQuerySubmitted.subscribe(with: self) { (viewController, _) in
      guard let link = viewController.queryRuleCustomDataConnector.interactor.item?.link else { return }
      if link.absoluteString == "algoliademo://help" {
        UIApplication.shared.open(link)
        let submitViewController = TemplateViewController()
        submitViewController.label.textAlignment = .center
        submitViewController.label.text = "Redirect via submit"
        viewController.present(UINavigationController(rootViewController: submitViewController), animated: true, completion: nil)
      }
    }.onQueue(.main)

    searcher.search()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(presentInfo))
  }
  
  @objc func presentInfo() {
    let message = """
    - Type "iphone" to show image banner. Click banner to redirect.\n
    - Type "discount" to show textual banner. Click banner to redirect.\n
    - Type "help" to activate redirect on submit. Submit by clicking "search" button on the keyboard to redirect.
    """
    let alertController = UIAlertController(title: "Help", message: message, preferredStyle: .alert)
    alertController.addAction(.init(title: "OK", style: .cancel, handler: nil))
    present(alertController, animated: true, completion: nil)
  }

}

private extension QueryRuleCustomDataDemoViewController {
  
  func configureUI() {
    title = "Amazing"
    view.backgroundColor = .white
    configureSearchBar()
    configureStatsLabel()
    configureStackView()
    configureLayout()
  }
  
  func configureSearchBar() {
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal
  }
  
  func configureStatsLabel() {
    statsController.label.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureStackView() {
    stackView.spacing = .px16
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func configureLayout() {
    
    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
    
    stackView.addArrangedSubview(searchBar)
    let statsContainer = UIView()
    statsContainer.translatesAutoresizingMaskIntoConstraints = false
    statsContainer.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    statsContainer.addSubview(statsController.label)
    statsController.label.pin(to: statsContainer.layoutMarginsGuide)
    stackView.addArrangedSubview(statsContainer)
    
    addChild(bannerViewController)
    bannerViewController.didMove(toParent: self)
    bannerViewController.view.isHidden = true
    bannerViewController.view.heightAnchor.constraint(lessThanOrEqualToConstant: 66.7).isActive = true
    stackView.addArrangedSubview(bannerViewController.view)
    
    stackView.addArrangedSubview(hitsTableViewController.view)
    
    view.addSubview(stackView)

    stackView.pin(to: view.safeAreaLayoutGuide)
    
    searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true

    statsController.label.heightAnchor.constraint(equalToConstant: 16).isActive = true

  }
  
}

