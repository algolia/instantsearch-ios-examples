//
//  StatsLabel.swift
//  ecommerce
//
//  Created by Guy Daher on 09/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import InstantSearchCore

@objc class StatsLabel: UILabel, AlgoliaWidget {
    private var searcher: Searcher?
    
    public var resultTemplate: String! // TODO: Unsafe, fix that
    public var errorTemplate: String?
    
    private let defaultResultTemplate = "{nbHits} results found in {processingTimeMS} ms"
    
    
    func initWith(searcher: Searcher) {
        self.searcher = searcher
        
        if self.resultTemplate == nil {
            self.resultTemplate = defaultResultTemplate
        }
        
        if let results = searcher.results {
            text = applyTemplate(resultTemplate: resultTemplate, results: results)
        }
    }
    
    func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        if let results = results {
            text = applyTemplate(resultTemplate: resultTemplate, results: results)
        }
        
        if error != nil {
            text = "Error in fetching results"
        }
    }
    
    // MARK: - Helper methods
    
    private func applyTemplate(resultTemplate: String, results: SearchResults) -> String{
        return resultTemplate.replacingOccurrences(of: "{hitsPerPage}", with: "\(results.hitsPerPage)")
            .replacingOccurrences(of: "{processingTimeMS}", with: "\(results.processingTimeMS)")
            .replacingOccurrences(of: "{nbHits}", with: "\(results.nbHits)")
            .replacingOccurrences(of: "{nbPages}", with: "\(results.nbPages)")
            .replacingOccurrences(of: "{page}", with: "\(results.page)")
            .replacingOccurrences(of: "{query}", with: "\(results.query)")
    }
}
