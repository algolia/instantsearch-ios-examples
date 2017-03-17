//
//  HitsCollectionView.swift
//  ecommerce
//
//  Created by Guy Daher on 17/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

public class HitsCollectionView: UICollectionView, AlgoliaWidget, AlgoliaTableHitDataSource {
    
    var searcher: Searcher!
    
    @objc func initWith(searcher: Searcher) {
        self.searcher = searcher
        
        if searcher.hits != nil {
            reloadData()
        }
    }
    
    @objc func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        // TODO: Work on that...
        if searcher.hits != nil {
            reloadData()
        }
        
        // TODO: Use that efficiently
        //hits.scrollToFirstRow()
    }
    
    func loadMoreIfNecessary(rowNumber: Int) {
        guard let hits = searcher.hits else { return }
        if rowNumber + 5 >= hits.count {
            searcher.loadMore()
        }
    }
    
    @objc func onReset() {
        
    }
    
    func numberOfRows(in section: Int) -> Int {
        return searcher.hits?.count ?? 0
    }
    
    func hitForRow(at indexPath: IndexPath) -> [String: Any] {
        loadMoreIfNecessary(rowNumber: indexPath.row)
        return searcher.hits![indexPath.row]
    }
}
