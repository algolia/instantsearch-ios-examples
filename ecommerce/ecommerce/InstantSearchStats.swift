//
//  InstantSearchStats.swift
//  ecommerce
//
//  Created by Guy Daher on 17/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

protocol InstantSearchStats {
    var text: String? { get set }
    func subscribeToSearchResultNotification()
}

// TODO: UITextView also has a text property, but it is not optional.
// We can solve this by creating a new property nbHits that will change text, but
// will have to add stored property in order to achieve that.
extension UILabel: InstantSearchStats {
    func subscribeToSearchResultNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onResultNotification(notification:)), name: Searcher.ResultNotification, object: nil)
    }
    
    func onResultNotification(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let searchResults  = userInfo[Searcher.resultNotificationResultsKey] as? SearchResults else {
                print("no search results found")
                return
        }
        
        text = "\(searchResults.nbHits) results"
    }
}
extension UITextField: InstantSearchStats {
    func subscribeToSearchResultNotification() {
        
    }
}

extension InstantSearch {
    func addWidget( stats: InstantSearchStats) {
        var stats = stats
        stats.subscribeToSearchResultNotification()
        if let results = results {
            stats.text = "\(results.nbHits) results"
        }
    }
}
