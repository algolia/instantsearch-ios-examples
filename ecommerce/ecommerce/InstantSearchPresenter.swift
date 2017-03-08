//
//  InstantSearchPresenter.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import InstantSearchCore

@objc class InstantSearchPresenter : NSObject, SearcherDelegate {
    
    // All widgets, including the specific ones such as refinementControlWidget
    // Note: Wish we could do a Set, but Swift doesn't support Set<GenericProtocol> for now.
    private var algoliaWidgets: [AlgoliaWidget] = []
    private var refinementControlWidget: [RefinementControlWidget] = []
    private var searcher: Searcher
    
    @objc public init(searcher: Searcher) {
        self.searcher = searcher
        super.init()
        self.searcher.delegate = self
    }
    
    @objc public func add(widget: AlgoliaWidget) {
        guard !algoliaWidgets.contains(where: { $0 === widget } ) else { return }
        
        widget.initWith(searcher: searcher)
        algoliaWidgets.append(widget)
    }
    
    @objc public func addRefinementControl(widget: RefinementControlWidget) {
        guard !refinementControlWidget.contains(where: { $0 === widget } ) else { return }
        
        widget.initWith(searcher: searcher)
        widget.registerValueChangedAction()
        algoliaWidgets.append(widget)
        refinementControlWidget.append(widget)

    }
    
    func searcher(_ searcher: Searcher, didReceive results: SearchResults?, error: Error?, userInfo: [String : Any]) {
        for algoliaWidget in algoliaWidgets {
            algoliaWidget.on(results: results, error: error, userInfo: userInfo)
        }
    }
}
