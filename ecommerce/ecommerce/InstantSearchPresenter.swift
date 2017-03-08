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
    
    // MARK: - Properties
    
    // All widgets, including the specific ones such as refinementControlWidget
    // Note: Wish we could do a Set, but Swift doesn't support Set<GenericProtocol> for now.
    private var algoliaWidgets: [AlgoliaWidget] = []
    private var refinementControlWidgets: [RefinementControlWidget] = []
    private var refinementWidgetMap: [String: [RefinementControlWidget]] = [:]
    
    private var searcher: Searcher
    
    // MARK: - Init
    
    @objc public init(searcher: Searcher) {
        self.searcher = searcher
        super.init()
        self.searcher.delegate = self
        
        // TODO: should we use nil for queue (OperationQueue) synchronous or not? Check..
        NotificationCenter.default.addObserver(self, selector: #selector(onReset(notification:)), name: clearAllFiltersNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRefinementNotification(notification:)), name: Searcher.RefinementChangeNotification, object: nil)
    }
    
    // MARK: Add widget methods
    
    @objc public func add(widget: AlgoliaWidget) {
        guard !algoliaWidgets.contains(where: { $0 === widget } ) else { return }
        
        widget.initWith(searcher: searcher)
        algoliaWidgets.append(widget)
    }
    
    @objc public func addRefinementControl(widget: RefinementControlWidget) {
        guard !refinementControlWidgets.contains(where: { $0 === widget } ) else { return }
        
        widget.initWith(searcher: searcher)
        widget.registerValueChangedAction()
        algoliaWidgets.append(widget)
        refinementControlWidgets.append(widget)
        
        guard let attributeName = widget.getAttributeName?() else { return }
        
        if refinementWidgetMap[attributeName] == nil {
            refinementWidgetMap[attributeName] = []
        }
        
        refinementWidgetMap[attributeName]!.append(widget)
    }
    
    // MARK: - Notification Observers
    
    func onReset(notification: Notification) {
        for algoliaWidget in algoliaWidgets {
            algoliaWidget.onReset?()
        }
    }
    
    func onRefinementNotification(notification: Notification) {
        let numericRefinementMap =  notification.userInfo?[Searcher.notificationNumericRefinementChangeKey] as? [String: [NumericRefinement]]
        let facetRefinementMap =  notification.userInfo?[Searcher.notificationFacetRefinementChangeKey] as? [String: [FacetRefinement]]
        
        callGeneralRefinementChanges(numericRefinementMap: numericRefinementMap, facetRefinementMap: facetRefinementMap)
        callSpecificNumericChanges(numericRefinementMap: numericRefinementMap)
        callSpecificFacetChanges(facetRefinementMap: facetRefinementMap)
    }
    
    
    // MARK: - SearcherDelegate
    
    internal func searcher(_ searcher: Searcher, didReceive results: SearchResults?, error: Error?, userInfo: [String : Any]) {
        for algoliaWidget in algoliaWidgets {
            algoliaWidget.on(results: results, error: error, userInfo: userInfo)
        }
    }
    
    // MARK: - Helper methods
    
    private func callGeneralRefinementChanges(numericRefinementMap:[String: [NumericRefinement]]?, facetRefinementMap: [String: [FacetRefinement]]?) {
        for refinementControlWidget in refinementControlWidgets {
            refinementControlWidget.onRefinementChange?(numerics: numericRefinementMap)
            refinementControlWidget.onRefinementChange?(facets: facetRefinementMap)
        }
    }
    
    private func callSpecificNumericChanges(numericRefinementMap:[String: [NumericRefinement]]?) {
        if let numericRefinementMap = numericRefinementMap {
            for (refinementName, numericRefinement) in numericRefinementMap {
                if let widgets = refinementWidgetMap[refinementName] {
                    for widget in widgets {
                        widget.onRefinementChange?(numeric: numericRefinement)
                    }
                }
            }
        }
    }
    
    private func callSpecificFacetChanges(facetRefinementMap:[String: [FacetRefinement]]?) {
        if let facetRefinementMap = facetRefinementMap {
            for (refinementName, facetRefinement) in facetRefinementMap {
                if let widgets = refinementWidgetMap[refinementName] {
                    for widget in widgets {
                        widget.onRefinementChange?(facet: facetRefinement)
                    }
                }
            }
        }
    }
}
