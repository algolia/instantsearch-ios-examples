//: Playground - noun: a place where people can play

import UIKit
import InstantSearchCore
import AlgoliaSearch


class InstantSearch: NSObject, SearcherDelegate {
    
    var searcher: Searcher!
    
    init(searcher: Searcher) {
        self.searcher = searcher
        super.init()
        
        let x = 5
        self.searcher.delegate = self
        self.searcher.search()
        self.searcher.search()
        self.searcher.search()
    }
    
    public func searcher(_ searcher: Searcher, didReceive results: SearchResults?, error: Error?, userInfo: [String:Any]) {
        let x = results?.nbHits
    }
}


private let ALGOLIA_APP_ID = "latency"
private let ALGOLIA_INDEX_NAME = "bestbuy_promo"
private let ALGOLIA_API_KEY = "1f6fd3a6fb973cb08419fe7d288fa4db"

let client = Client(appID: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY)
let index = client.index(withName: ALGOLIA_INDEX_NAME)


func handleSearchResults(results: SearchResults?, error: Error?) {
    let results = results?.nbHits
    var x = 6
}

let searcher = Searcher(index: index)

searcher.params.attributesToRetrieve = ["name", "salePrice"]
searcher.params.attributesToHighlight = ["name"]
searcher.params.facets = ["category", "manufacturer"]
searcher.params.hitsPerPage = 15
let instantSearch = InstantSearch(searcher: searcher)


var x = 5