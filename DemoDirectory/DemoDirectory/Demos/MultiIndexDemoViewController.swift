//
//  MultiIndexDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 09/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

extension HitViewModel {
  
  static func movie(_ movie: Movie) -> Self {
    return HitViewModel()
      .set(\.imageViewConfigurator) { imageView in
        imageView.sd_setImage(with: movie.image, completed: .none)
        imageView.contentMode = .scaleAspectFit
      }
      .set(\.mainTitleConfigurator) { label in
        label.text = movie.title
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
      }
      .set(\.secondaryTitleConfigurator) { label in
        label.text = "\(movie.year)"
        label.font = .systemFont(ofSize: 12, weight: .regular)
      }
      .set(\.detailsTitleConfigurator) { label in
        label.text = movie.genre.joined(separator: ", ")
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 0
      }
  }
  
}

enum MultiIndexDemoSection: CaseIterable {
  
  case movies
  case actors
  
  var index: Int {
    return MultiIndexDemoSection.allCases.firstIndex(of: self)!
  }
  
  var title: String {
    switch self {
    case .actors:
      return "Actors"
    case .movies:
      return "Movies"
    }
  }
  
  var indexName: IndexName {
    switch self {
    case .actors:
      return "mobile_demo_actors"
      
    case .movies:
      return "mobile_demo_movies"
    }
  }
  
  var cellIdentifier: String {
    switch self {
    case .actors:
      return "actorCell"
    case .movies:
      return "movieCell"
    }
  }
  
}

class MultiIndexDemoViewController: UIViewController {
    
  let textFieldController: TextFieldController
  let queryInputConnector: QueryInputConnector<MultiIndexSearcher>
  let multiIndexHitsConnector: MultiIndexHitsConnector
  let searchBar: UISearchBar
  let hitsViewController: MultiIndexHitsViewController

  init() {
    searchBar = UISearchBar()
    
    textFieldController = .init(searchBar: searchBar)
    
    hitsViewController = .init()
    
    let indexModules: [MultiIndexHitsConnector.IndexModule] = [
      .init(indexName: MultiIndexDemoSection.movies.indexName, hitsInteractor: HitsInteractor<Movie>(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true)),
      .init(indexName: MultiIndexDemoSection.actors.indexName, hitsInteractor: HitsInteractor<Hit<Actor>>(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true)),
    ]
    
    multiIndexHitsConnector = .init(appID: SearchClient.demo.applicationID,
                                    apiKey: SearchClient.demo.apiKey,
                                    indexModules: indexModules,
                                    controller: hitsViewController)
    
    queryInputConnector = .init(searcher: multiIndexHitsConnector.searcher, controller: textFieldController)
    
    super.init(nibName: nil, bundle: nil)
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

private extension MultiIndexDemoViewController {
    
  func setup() {
    multiIndexHitsConnector.searcher.search()
    addChild(hitsViewController)
    hitsViewController.didMove(toParent: self)
  }
  
  func setupUI() {
    view.backgroundColor = UIColor(hexString: "#f7f8fa")
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = .px16 / 2
    
    view.addSubview(stackView)
    
    stackView.pin(to: view.safeAreaLayoutGuide)
    
    searchBar.searchBarStyle = .minimal
    searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(hitsViewController.view)
    stackView.addArrangedSubview(UIView().set(\.translatesAutoresizingMaskIntoConstraints, to: false))
  }

}

class MultiIndexHitsViewController: UIViewController, MultiIndexHitsController {
  
  let moviesCollectionView: UICollectionView
  let actorsCollectionView: UICollectionView
  
  weak var hitsSource: MultiIndexHitsSource?
  
  init() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    moviesCollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
    
    let actorsFlowLayout = UICollectionViewFlowLayout()
    actorsFlowLayout.scrollDirection = .horizontal
    actorsCollectionView = .init(frame: .zero, collectionViewLayout: actorsFlowLayout)
        
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func reload() {
    moviesCollectionView.reloadData()
    actorsCollectionView.reloadData()
  }
  
  func scrollToTop() {
    moviesCollectionView.scrollToFirstNonEmptySection()
    actorsCollectionView.scrollToFirstNonEmptySection()
  }
  
  func section(for collectionView: UICollectionView) -> MultiIndexDemoSection? {
    switch collectionView {
    case moviesCollectionView:
      return .movies
      
    case actorsCollectionView:
      return .actors

    default:
      return .none
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    configureCollectionView()
    moviesCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    actorsCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    let stackView = UIStackView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.axis, to: .vertical)
      .set(\.spacing, to: .px16)
    
    stackView.addArrangedSubview(UILabel()
                                  .set(\.text, to: MultiIndexDemoSection.movies.title)
                                  .set(\.font, to: .systemFont(ofSize: 15, weight: .black))
    )
    stackView.addArrangedSubview(moviesCollectionView)
    stackView.addArrangedSubview(UILabel()
                                  .set(\.text, to: MultiIndexDemoSection.actors.title)
                                  .set(\.font, to: .systemFont(ofSize: 15, weight: .black))
    )
    stackView.addArrangedSubview(actorsCollectionView)
    
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide, insets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
  }
  
  func configureCollectionView() {
    moviesCollectionView.register(HitCollectionViewCell.self, forCellWithReuseIdentifier: MultiIndexDemoSection.movies.cellIdentifier)
    actorsCollectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: MultiIndexDemoSection.actors.cellIdentifier)
    [moviesCollectionView, actorsCollectionView].forEach { collectionView in
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      collectionView.dataSource = self
      collectionView.delegate = self
      collectionView.backgroundColor = .clear
    }
  }
  
}

extension MultiIndexHitsViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let section = section(for: collectionView) else { return .zero }
    switch section {
    case .movies:
      return CGSize(width: collectionView.bounds.width / 2 - 10, height: collectionView.bounds.height - 10)

    case .actors:
      return CGSize(width: collectionView.bounds.width / 3, height: 40)
    }
  }

}


extension MultiIndexHitsViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let section = self.section(for: collectionView) else { return 0 }
    return hitsSource?.numberOfHits(inSection: section.index) ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let section = self.section(for: collectionView) else { return UICollectionViewCell() }
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.cellIdentifier, for: indexPath)
    
    switch section {
    case .movies:
      if let item: Movie = try? hitsSource?.hit(atIndex: indexPath.row, inSection: section.index),
        let cell = cell as? HitCollectionViewCell {
        HitViewModel.movie(item).configure(cell.hitView)
      }
      
    case .actors:
      if let actor: Hit<Actor> = try? hitsSource?.hit(atIndex: indexPath.row, inSection: section.index) {
        (cell as? ActorCollectionViewCell).flatMap(ActorHitCollectionViewCellViewState().configure)?(actor)
      }
    }

    return cell
  }
  
}
