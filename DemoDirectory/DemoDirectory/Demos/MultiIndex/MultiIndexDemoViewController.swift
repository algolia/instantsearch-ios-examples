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
  
  case actors
  case movies
  
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
  
  let queryInputConnector: QueryInputConnector
  let searchBar: UISearchBar
  
  let multiSearcher: MultiSearcher
  let moviesHitsConnector: HitsConnector<Movie>
  let actorsHitsConnector: HitsConnector<Hit<Actor>>
  
  let hitsViewController: MultiIndexHitsViewController
  
  init() {
    searchBar = UISearchBar()
    
    textFieldController = .init(searchBar: searchBar)
    
    hitsViewController = .init()
    
    multiSearcher = MultiSearcher(appID: SearchClient.demo.applicationID,
                                  apiKey: SearchClient.demo.apiKey)
    
    let moviesSearcher = multiSearcher.addHitsSearcher(indexName: MultiIndexDemoSection.movies.indexName)
    let actorsSearcher = multiSearcher.addHitsSearcher(indexName: MultiIndexDemoSection.actors.indexName)
    
    queryInputConnector = .init(searcher: multiSearcher,
                                controller: textFieldController)
    moviesHitsConnector = .init(searcher: moviesSearcher,
                                controller: hitsViewController.moviesCollectionViewController)
    actorsHitsConnector = .init(searcher: actorsSearcher,
                                controller: hitsViewController.actorsCollectionViewController)
    
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
    multiSearcher.search()
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

class MoviesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HitsController {
  
  var hitsSource: HitsInteractor<Movie>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .clear
    collectionView.register(HitCollectionViewCell.self, forCellWithReuseIdentifier: MultiIndexDemoSection.movies.cellIdentifier)
  }
  
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
    return CGSize(width: collectionView.bounds.width / 2 - 10, height: collectionView.bounds.height - 10)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultiIndexDemoSection.movies.cellIdentifier, for: indexPath)
    
    if let item: Movie = hitsSource?.hit(atIndex: indexPath.row),
      let cell = cell as? HitCollectionViewCell {
      HitViewModel.movie(item).configure(cell.hitView)
    }
    
    return cell
  }
  
}

class ActorsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HitsController {
  
  var hitsSource: HitsInteractor<Hit<Actor>>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = .clear
    collectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: MultiIndexDemoSection.actors.cellIdentifier)
  }

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
    return CGSize(width: collectionView.bounds.width / 3, height: 40)
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MultiIndexDemoSection.actors.cellIdentifier, for: indexPath)
    
    if let actor = hitsSource?.hit(atIndex: indexPath.row) {
      (cell as? ActorCollectionViewCell).flatMap(ActorHitCollectionViewCellViewState().configure)?(actor)
    }

    return cell
  }
  
}


class MultiIndexHitsViewController: UIViewController {
  
  let moviesCollectionViewController: MoviesCollectionViewController
  let actorsCollectionViewController: ActorsCollectionViewController
  
  init() {
    let moviesFlowLayout = UICollectionViewFlowLayout()
    moviesFlowLayout.scrollDirection = .horizontal
    moviesCollectionViewController = .init(collectionViewLayout: moviesFlowLayout)

    let actorsFlowLayout = UICollectionViewFlowLayout()
    actorsFlowLayout.scrollDirection = .horizontal
    actorsCollectionViewController = .init(collectionViewLayout: actorsFlowLayout)
        
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
    configureCollectionView()
    
    addChild(moviesCollectionViewController)
    moviesCollectionViewController.didMove(toParent: self)
    
    addChild(actorsCollectionViewController)
    actorsCollectionViewController.didMove(toParent: self)
    
    moviesCollectionViewController.collectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    actorsCollectionViewController.collectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    let stackView = UIStackView()
      .set(\.translatesAutoresizingMaskIntoConstraints, to: false)
      .set(\.axis, to: .vertical)
      .set(\.spacing, to: .px16)
    
    stackView.addArrangedSubview(UILabel()
                                  .set(\.text, to: MultiIndexDemoSection.movies.title)
                                  .set(\.font, to: .systemFont(ofSize: 15, weight: .black))
    )
    stackView.addArrangedSubview(moviesCollectionViewController.collectionView)
    stackView.addArrangedSubview(UILabel()
                                  .set(\.text, to: MultiIndexDemoSection.actors.title)
                                  .set(\.font, to: .systemFont(ofSize: 15, weight: .black))
    )
    stackView.addArrangedSubview(actorsCollectionViewController.collectionView)
    
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide, insets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
  }
  
  func configureCollectionView() {
    [
      moviesCollectionViewController,
      actorsCollectionViewController
    ].forEach { controller in
      controller.view?.translatesAutoresizingMaskIntoConstraints = false
      controller.view?.backgroundColor = .clear
    }
  }
  
}
