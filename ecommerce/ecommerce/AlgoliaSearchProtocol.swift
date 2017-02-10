//
//  AlgoliaSearchProtocol.swift
//  ecommerce
//
//  Created by Guy Daher on 10/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore
import AlgoliaSearch

protocol AlgoliaSearchProtocol {
    var searcher: Searcher { get }
    // TODO: Potentially a tableView. And can create another protocol for a CollectionView, and then a custom View...
}
