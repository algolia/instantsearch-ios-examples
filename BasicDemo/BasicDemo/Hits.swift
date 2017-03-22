//
//  Hits.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

public protocol HitsWidget {
    func reloadData()
    func scrollToFirstRow()
}

extension UITableView: HitsWidget {
    public func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
extension UICollectionView: HitsWidget {
    public func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        scrollToItem(at: indexPath, at: .top, animated: true)
    }
}

public class Hits: AlgoliaWidget {
    
    var hits: HitsWidget
    var searcher: Searcher!
    var hitDataSource: AlgoliaHitDataSource?
    
    public init(hits: HitsWidget) {
        self.hits = hits
    }
    
    public convenience init(tableView: UITableView) {
        self.init(hits: tableView)
    }
    
    public convenience init(collectionView: UICollectionView) {
        self.init(hits: collectionView)
    }
    
    @objc func initWith(searcher: Searcher) {
        self.searcher = searcher
        
        if let hits = searcher.hits {
            hitDataSource?.handle(hits: hits) // Make the handle function optional.
            self.hits.reloadData()
        }
    }
    
    @objc func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        // TODO: Work on that...
        if let hits = searcher.hits {
            hitDataSource?.handle(hits: hits) // Make the handle function optional.
        }
        hits.reloadData()
        // TODO: Use that efficiently
        //hits.scrollToFirstRow()
    }
    
    @objc func onReset() {
        
    }
}
