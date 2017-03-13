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

@objc class Stats: NSObject, AlgoliaWidget {
    var label: UILabel
    private var searcher: Searcher?
    
    public var resultTemplate: String
    public var errorTemplate: String?
    
    private let defaultResultTemplate = "{nbHits} results found in {processingTimeMS} ms"
    
    // MARK: - AlgoliaWidget
    init(label: UILabel) {
        self.label = label
        self.resultTemplate = defaultResultTemplate
    }
    
    init(label: UILabel, resultTemplate: String) {
        self.label = label
        self.resultTemplate = resultTemplate
    }
    
    func initWith(searcher: Searcher) {
        self.searcher = searcher
        
        if let results = searcher.results {
            label.text = applyTemplate(resultTemplate: resultTemplate, results: results)
        }
    }
    
    func on(results: SearchResults?, error: Error?, userInfo: [String: Any]) {
        if let results = results {
            label.text = applyTemplate(resultTemplate: resultTemplate, results: results)
        }
        
        if error != nil {
            label.text = "Error in fetching results"
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
