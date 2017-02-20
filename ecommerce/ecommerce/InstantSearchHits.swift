//
//  InstantSearchHits.swift
//  ecommerce
//
//  Created by Guy Daher on 17/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit

public protocol InstantSearchHits {
    func reloadData()
}

extension UITableView: InstantSearchHits {}
extension UICollectionView: InstantSearchHits {}

extension InstantSearch {
    func addWidget(hits: InstantSearchHits) {
        self.hits.append(hits)
        reloadAllWidgets()
    }
}
