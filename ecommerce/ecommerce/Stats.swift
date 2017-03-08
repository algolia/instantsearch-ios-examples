//
//  Stats.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

@objc class Stats: UILabel, AlgoliaWidget, SearchProgressDelegate {
    
    var searcher: Searcher?
    var searchProgressController: SearchProgressController?
    
    public var resultTemplate: String?
    public var errorTemplate: String?
    
    private let defaultResultTemplate = "{nbHits} results found in {processingTimeMS} ms"
    
    // MARK: - AlgoliaWidget
    
    func initWith(searcher: Searcher) {
        self.searcher = searcher
        
        if resultTemplate == nil {
            self.resultTemplate = defaultResultTemplate
        }
        
        searchProgressController = SearchProgressController(searcher: searcher)
        searchProgressController?.graceDelay = 0.01
        searchProgressController?.delegate = self
    }
    
    func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        if let results = results {
        text = resultTemplate?.replacingOccurrences(of: "{hitsPerPage}", with: "\(results.hitsPerPage)")
            .replacingOccurrences(of: "{processingTimeMS}", with: "\(results.processingTimeMS)")
            .replacingOccurrences(of: "{nbHits}", with: "\(results.nbHits)")
            .replacingOccurrences(of: "{nbPages}", with: "\(results.nbPages)")
            .replacingOccurrences(of: "{page}", with: "\(results.page)")
            .replacingOccurrences(of: "{query}", with: "\(results.query)")
        }
        
        if error != nil {
            text = "Error in fetching results"
        }
    }
    
    // MARK: - SearchProgressDelegate
    
    func searchDidStart(_ searchProgressController: SearchProgressController) {
        text = "searching..."
    }
    
    func searchDidStop(_ searchProgressController: SearchProgressController) {
        
    }
}
