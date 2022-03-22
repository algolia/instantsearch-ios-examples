//
//  HitView.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/06/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import UIKit

class HitView: UIView {
  
  var isHorizontal: Bool = true {
    didSet {
      orientationTransition()
    }
  }
  
  let mainStackView: UIStackView
  let detailsStackView: UIStackView
  let titlesStackView: UIStackView
  let auxilaryStackView: UIStackView
  
  var placeholderImage: UIImage?
  
  let imageView: UIImageView
  let mainTitleLabel: UILabel
  let secondaryTitleLabel: UILabel
  let detailsTitleLabel: UILabel
  let auxilaryTitleLabel: UILabel
  
  var imageViewConstraint: NSLayoutConstraint? = nil
  
  override init(frame: CGRect) {
    mainStackView = .init()
    detailsStackView = .init()
    titlesStackView = .init()
    auxilaryStackView = .init()
    imageView = .init()
    mainTitleLabel = .init()
    secondaryTitleLabel = .init()
    detailsTitleLabel = .init()
    auxilaryTitleLabel = .init()
    super.init(frame: frame)
    backgroundColor = .white
    setupLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func orientationTransition() {
    mainStackView.axis = isHorizontal ? .horizontal : .vertical
    if let imageViewConstraint = imageViewConstraint {
      imageViewConstraint.isActive = false
      imageView.removeConstraint(imageViewConstraint)
    }
    if isHorizontal {
      imageViewConstraint = imageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25)
    } else {
      imageViewConstraint = imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5)
    }
    imageViewConstraint?.isActive = true
  }
  
  func setupLayout() {
    translatesAutoresizingMaskIntoConstraints = false
    imageView.image = placeholderImage
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    [mainTitleLabel, secondaryTitleLabel, detailsTitleLabel, auxilaryTitleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.spacing = 16
    mainStackView.addArrangedSubview(imageView)
    mainStackView.addArrangedSubview(detailsStackView)
    
    detailsStackView.translatesAutoresizingMaskIntoConstraints = false
    detailsStackView.axis = .horizontal
    detailsStackView.addArrangedSubview(titlesStackView)
    detailsStackView.addArrangedSubview(UIView())
    detailsStackView.addArrangedSubview(auxilaryStackView)
    
    titlesStackView.translatesAutoresizingMaskIntoConstraints = false
    titlesStackView.axis = .vertical
    titlesStackView.spacing = 5
    titlesStackView.addArrangedSubview(mainTitleLabel)
    titlesStackView.addArrangedSubview(secondaryTitleLabel)
    titlesStackView.addArrangedSubview(detailsTitleLabel)
    titlesStackView.addArrangedSubview(UIView())
    
    auxilaryStackView.translatesAutoresizingMaskIntoConstraints = false
    auxilaryStackView.axis = .vertical
    auxilaryStackView.addArrangedSubview(auxilaryTitleLabel)
    
    addSubview(mainStackView)

    NSLayoutConstraint.activate([
      mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
      mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
      mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
    ])
    
    orientationTransition()
  }
  
}

typealias ViewConfigurator<V: UIView> = (V) -> Void

struct HitViewModel: Builder {
  
  var imageViewConfigurator: ViewConfigurator<UIImageView>?
  var mainTitleConfigurator: ViewConfigurator<UILabel>?
  var secondaryTitleConfigurator: ViewConfigurator<UILabel>?
  var detailsTitleConfigurator: ViewConfigurator<UILabel>?
  var auxilaryTitleConfigurator: ViewConfigurator<UILabel>?
    
  func configure(_ hitView: HitView) {
    imageViewConfigurator?(hitView.imageView)
    mainTitleConfigurator?(hitView.mainTitleLabel)
    secondaryTitleConfigurator?(hitView.secondaryTitleLabel)
    detailsTitleConfigurator?(hitView.detailsTitleLabel)
    auxilaryTitleConfigurator?(hitView.auxilaryTitleLabel)
  }
  
}

extension HitViewModel {
  
  static var template: HitViewModel = {
    return HitViewModel()
      .set(\.imageViewConfigurator) { imageView in imageView.image = UIImage(named: "imagePlaceholder") }
      .set(\.mainTitleConfigurator) { label in label.text = "Main title" }
      .set(\.secondaryTitleConfigurator) { label in label.text = "Secondary title" }
      .set(\.detailsTitleConfigurator) { label in label.text = "Details title" }
      .set(\.auxilaryTitleConfigurator) { label in label.text = "Auxilary title" }
  }()
  
  static func shopItem(_ item: ShopItem) -> HitViewModel {
    return HitViewModel()
      .set(\.imageViewConfigurator) { imageView in
        imageView.sd_setImage(with: item.image, completed: .none)
        imageView.contentMode = .scaleAspectFit
      }
      .set(\.mainTitleConfigurator) { label in
        label.text = item.name
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
      }
      .set(\.secondaryTitleConfigurator) { label in
        label.text = item.brand
        label.font = .systemFont(ofSize: 12, weight: .regular)
      }
      .set(\.detailsTitleConfigurator) { label in
        label.text = item.description
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 0
      }
//      .set(\.auxilaryTitleConfigurator) { label in
//        label.text = "$100"
//        label.font = .systemFont(ofSize: 25, weight: .bold)
//      }
  }
  
  static func ecomProductItem(_ item: Hit<StoreItem>) -> HitViewModel {
    return HitViewModel()
      .set(\.imageViewConfigurator) { imageView in
        imageView.sd_setImage(with: item.object.images.first, completed: .none)
        imageView.contentMode = .scaleAspectFit
      }
      .set(\.mainTitleConfigurator) { label in
        label.text = item.object.name
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
      }
      .set(\.secondaryTitleConfigurator) { label in
        label.text = item.object.brand
        label.font = .systemFont(ofSize: 12, weight: .regular)
      }
      .set(\.detailsTitleConfigurator) { label in
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 0
      }
//      .set(\.auxilaryTitleConfigurator) { label in
//        label.text = "$100"
//        label.font = .systemFont(ofSize: 25, weight: .bold)
//      }
  }

  
}

class HitTableViewCell: UITableViewCell {
  
  let hitView: HitView
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    hitView = .init()
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureLayout() {
    contentView.addSubview(hitView)
    NSLayoutConstraint.activate([
      hitView.topAnchor.constraint(equalTo: contentView.topAnchor),
      hitView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      hitView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      hitView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
  }
  
}

class HitCollectionViewCell: UICollectionViewCell {
  
  let hitView: HitView
  
  override init(frame: CGRect) {
    hitView = .init()
    super.init(frame: frame)
    hitView.isHorizontal = false
    configureLayout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureLayout() {
    contentView.addSubview(hitView)
    NSLayoutConstraint.activate([
      hitView.topAnchor.constraint(equalTo: contentView.topAnchor),
      hitView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      hitView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      hitView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    ])
  }
  
}


class ResultsTableViewController: UITableViewController, HitsController {
  
  var hitsSource: HitsInteractor<ShopItem>?
  
  let cellID = "cellID"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(HitTableViewCell.self, forCellReuseIdentifier: cellID)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return hitsSource?.numberOfHits() ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? HitTableViewCell else {
      return .init()
    }
    hitsSource?.hit(atIndex: indexPath.row).flatMap(HitViewModel.shopItem)?.configure(cell.hitView)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
}
