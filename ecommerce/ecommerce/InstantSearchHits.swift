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
    func scrollToFirstRow()
}

extension UITableView: InstantSearchHits {
    public func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
extension UICollectionView: InstantSearchHits {
    public func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        scrollToItem(at: indexPath, at: .top, animated: true)
    }
}

extension InstantSearch {
    func addWidget(hits: InstantSearchHits) {
        self.hits.append(hits)
        reloadAllWidgets()
    }
}
