//
//  UIView+Layout.swift
//  development-pods-instantsearch
//
//  Created by Vladislav Fitc on 18/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
  func pin(to view: UIView) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: view.topAnchor),
      bottomAnchor.constraint(equalTo: view.bottomAnchor),
      leadingAnchor.constraint(equalTo: view.leadingAnchor),
      trailingAnchor.constraint(equalTo: view.trailingAnchor),
      ])
  }
  
  func pin(to layoutGuide: UILayoutGuide) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
      leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      ])
  }
  
}
