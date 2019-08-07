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

class MultiIndexDemoViewController: UIViewController, InstantSearchCore.MultiIndexHitsController {
  
  func reload() {
    moviesCollectionView.reloadData()
    actorsCollectionView.reloadData()
  }
  
  func scrollToTop() {
    moviesCollectionView.scrollToFirstNonEmptySection()
    actorsCollectionView.scrollToFirstNonEmptySection()
  }

  weak var hitsSource: MultiIndexHitsSource?
  
  let multiIndexSearcher: MultiIndexSearcher
  let searchBarController: SearchBarController
  let queryInputInteractor: QueryInputInteractor
  let multiIndexHitsInteractor: MultiIndexHitsInteractor
  let moviesCollectionView: UICollectionView
  let actorsCollectionView: UICollectionView
  let cellIdentifier = "CellID"

  init() {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    moviesCollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
    
    let actorsFlowLayout = UICollectionViewFlowLayout()
    actorsFlowLayout.scrollDirection = .horizontal
    actorsCollectionView = .init(frame: .zero, collectionViewLayout: actorsFlowLayout)
    
    let indices = [
      Section.movies.index,
      Section.actors.index,
    ]
    multiIndexSearcher = .init(client: .demo, indices: indices)
    
    let hitsInteractors: [AnyHitsInteractor] = [
      HitsInteractor<Hit<Movie>>(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
      HitsInteractor<Hit<Actor>>(infiniteScrolling: .on(withOffset: 10), showItemsOnEmptyQuery: true),
    ]
    
    multiIndexHitsInteractor = .init(hitsInteractors: hitsInteractors)

    searchBarController = .init(searchBar: .init())
    queryInputInteractor = .init()
    
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
  
  func section(for collectionView: UICollectionView) -> Section? {
    switch collectionView {
    case moviesCollectionView:
      return .movies
      
    case actorsCollectionView:
      return .actors

    default:
      return .none
    }
  }
  
  func setup() {
    queryInputInteractor.connectSearcher(multiIndexSearcher)
    queryInputInteractor.connectController(searchBarController)

    multiIndexHitsInteractor.connectSearcher(multiIndexSearcher)
    multiIndexHitsInteractor.connectController(self)
    
    multiIndexSearcher.search()
  }
  
  func configure(_ collectionView: UICollectionView) {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.backgroundColor = .clear
  }
  
  func configureCollectionView() {
    moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: Section.movies.cellIdentifier)
    actorsCollectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: Section.actors.cellIdentifier)
    configure(moviesCollectionView)
    configure(actorsCollectionView)
  }
  
  func setupUI() {
    
    configureCollectionView()

    view.backgroundColor = UIColor(hexString: "#f7f8fa")
    
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.spacing = .px16 / 2
    
    view.addSubview(stackView)
    
    stackView.pin(to: view.safeAreaLayoutGuide)
    
    searchBarController.searchBar.searchBarStyle = .minimal
    searchBarController.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
    moviesCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    actorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
    actorsCollectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    let moviesTitleLabel = UILabel(frame: .zero)
    moviesTitleLabel.text = "   Movies"
    moviesTitleLabel.font = .systemFont(ofSize: 15, weight: .black)
    moviesTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    let actorsTitleLabel = UILabel(frame: .zero)
    actorsTitleLabel.text = "   Actors"
    actorsTitleLabel.font = .systemFont(ofSize: 15, weight: .black)
    actorsTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    stackView.addArrangedSubview(searchBarController.searchBar)
    stackView.addArrangedSubview(moviesTitleLabel)
    stackView.addArrangedSubview(moviesCollectionView)
    let spacer = UIView()
    spacer.translatesAutoresizingMaskIntoConstraints = false
    spacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
    stackView.addSubview(spacer)
    stackView.addArrangedSubview(actorsTitleLabel)
    stackView.addArrangedSubview(actorsCollectionView)
    stackView.addArrangedSubview(UIView())
    
  }

}

extension MultiIndexDemoViewController {
  
  enum Section: Int {
    
    case movies
    case actors
    
    init?(section: Int) {
      self.init(rawValue: section)
    }
    
    init?(indexPath: IndexPath) {
      self.init(rawValue: indexPath.section)
    }
    
    var title: String {
      switch self {
      case .actors:
        return "Actors"
      case .movies:
        return "Movies"
      }
    }
    
    var index: Index {
      switch self {
      case .actors:
        return .demo(withName: "mobile_demo_actors")
        
      case .movies:
        return .demo(withName: "mobile_demo_movies")
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
  
}

extension MultiIndexDemoViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let section = self.section(for: collectionView) else { return 0 }
    return hitsSource?.numberOfHits(inSection: section.rawValue) ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let section = self.section(for: collectionView) else { return UICollectionViewCell() }
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.cellIdentifier, for: indexPath)
    
    switch section {
    case .movies:
      if let movie: Hit<Movie> = try? hitsSource?.hit(atIndex: indexPath.row, inSection: section.rawValue) {
        (cell as? MovieCollectionViewCell).flatMap(MovieHitCellViewState().configure)?(movie)
      }
      
    case .actors:
      if let actor: Hit<Actor> = try? hitsSource?.hit(atIndex: indexPath.row, inSection: section.rawValue) {
        (cell as? ActorCollectionViewCell).flatMap(ActorHitCollectionViewCellViewState().configure)?(actor)
      }
    }

    return cell
  }
  
}

extension MultiIndexDemoViewController: UICollectionViewDelegateFlowLayout {
  
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

