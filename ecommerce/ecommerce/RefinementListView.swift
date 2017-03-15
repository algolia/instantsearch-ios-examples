//
//  RefinementList.swift
//  ecommerce
//
//  Created by Guy Daher on 08/03/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchCore

@IBDesignable
class RefinementListView: UITableView, AlgoliaWidget {
    private var searcher: Searcher!
    var facetDataSource: AlgoliaFacetDataSource?
    @IBInspectable var facet: String?
    
    public weak var tableDelegate: UITableViewDelegate?
    
    func initWith(searcher: Searcher) {
        self.searcher = searcher
        delegate = self
        
        if let facet = facet, let results = searcher.results, let hits = searcher.hits, hits.count > 0 {
            let facetResults = searcher.getRefinementList(facetCounts: results.facets(name: facet), andFacetName: facet, transformRefinementList: .countDesc, areRefinedValuesFirst: true)
            
            facetDataSource?.handle(facetRecords: facetResults)
        }
    }
    
    func on(results: SearchResults?, error: Error?, userInfo: [String : Any]) {
        guard let facet = facet, searcher.params.hasFacetRefinements(name: facet) else { return }
        
        let facetResults = searcher.getRefinementList(facetCounts: results?.facets(name: facet), andFacetName: facet, transformRefinementList: .countDesc, areRefinedValuesFirst: true)
        
        facetDataSource?.handle(facetRecords: facetResults)
    }
    
    func onReset() {
        
    }
    
}

/// - warning: Not sure of the default implementation of the following:
/// - `indexPathForPreferredFocusedView(in:)`
///- `tableView(_:shouldUpdateFocusIn:)`
/// - warning: Currently, this class doesn't implement:
/// - `tableView(_:targetIndexPathForMoveFromRowAt: toProposedIndexPath:)`

extension RefinementListView: UITableViewDelegate {

    // Display customization
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableDelegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    @available(iOS 6.0, *)
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        tableDelegate?.tableView?(tableView, willDisplayHeaderView: view, forSection: section)
    }
    
    @available(iOS 6.0, *)
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        tableDelegate?.tableView?(tableView, willDisplayFooterView: view, forSection: section)
    }
    
    @available(iOS 6.0, *)
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableDelegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
    
    @available(iOS 6.0, *)
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        tableDelegate?.tableView?(tableView, didEndDisplayingHeaderView: view, forSection: section)
    }
    
    @available(iOS 6.0, *)
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        tableDelegate?.tableView?(tableView, didEndDisplayingFooterView: view, forSection: section)
    }
    
    
    // Variable height support
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableDelegate?.tableView?(tableView, heightForRowAt: indexPath) ?? UITableViewAutomaticDimension
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableDelegate?.tableView?(tableView, heightForHeaderInSection: section) ?? CGFloat(0)
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableDelegate?.tableView?(tableView, heightForFooterInSection: section) ?? CGFloat(0)
    }
    
    
    // Use the estimatedHeight methods to quickly calcuate guessed values which will allow for fast load times of the table.
    // If these methods are implemented, the above -tableView:heightForXXX calls will be deferred until views are ready to be displayed, so more expensive logic can be placed there.
    @available(iOS 7.0, *)
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableDelegate?.tableView?(tableView, estimatedHeightForRowAt: indexPath) ?? UITableViewAutomaticDimension
    }
    
    @available(iOS 7.0, *)
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return tableDelegate?.tableView?(tableView, estimatedHeightForHeaderInSection: section) ?? CGFloat(0)
    }
    
    @available(iOS 7.0, *)
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return tableDelegate?.tableView?(tableView, estimatedHeightForFooterInSection: section) ?? CGFloat(0)
    }
    
    
    // Section header & footer information. Views are preferred over title should you decide to provide both
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { // custom view for header. will be adjusted to default or specified header height
        return tableDelegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {// custom view for footer. will be adjusted to default or specified footer height
        return tableDelegate?.tableView?(tableView, viewForFooterInSection: section)
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        tableDelegate?.tableView?(tableView, accessoryButtonTappedForRowWith: indexPath)
    }
    
    
    // Selection
    
    // -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
    // Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
    @available(iOS 6.0, *)
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return tableDelegate?.tableView?(tableView, shouldHighlightRowAt: indexPath) ?? true
    }
    
    @available(iOS 6.0, *)
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableDelegate?.tableView?(tableView, didHighlightRowAt: indexPath)
    }
    
    @available(iOS 6.0, *)
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableDelegate?.tableView?(tableView, didUnhighlightRowAt: indexPath)
    }
    
    
    // Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return tableDelegate?.tableView?(tableView, willSelectRowAt: indexPath)
    }
    
    @available(iOS 3.0, *)
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return tableDelegate?.tableView?(tableView, willDeselectRowAt: indexPath)
    }
    
    // Called after the user changes the selection.
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    @available(iOS 3.0, *)
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableDelegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    
    // Editing
    
    // Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return tableDelegate?.tableView?(tableView, editingStyleForRowAt: indexPath) ?? .none
    }
    
    @available(iOS 3.0, *)
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return tableDelegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: indexPath)
    }
    
    @available(iOS 8.0, *)
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? { // supercedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
        return tableDelegate?.tableView?(tableView, editActionsForRowAt: indexPath)
    }
    
    // Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return tableDelegate?.tableView?(tableView, shouldIndentWhileEditingRowAt: indexPath) ?? false
    }
    
    
    // The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        tableDelegate?.tableView?(tableView, willBeginEditingRowAt: indexPath)
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        tableDelegate?.tableView?(tableView, didEndEditingRowAt: indexPath)
    }
    
    
    // Moving/reordering
    
    // Allows customization of the target row for a particular row as it is being moved/reordered
//    @available(iOS 2.0, *)
//    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//        return tableDelegate?.tableView?(tableView, targetIndexPathForMoveFromRowAt: sourceIndexPath, toProposedIndexPath: proposedDestinationIndexPath)
//    }
    
    
    // Indentation
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int { // return 'depth' of row for hierarchies
        return tableDelegate?.tableView?(tableView, indentationLevelForRowAt: indexPath) ?? 0
    }
    
    // Copy/Paste.  All three methods must be implemented by the delegate.
    
    @available(iOS 5.0, *)
    public func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return tableDelegate?.tableView?(tableView, shouldShowMenuForRowAt: indexPath) ?? false
    }
    
    @available(iOS 5.0, *)
    public func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return tableDelegate?.tableView?(tableView, canPerformAction: action, forRowAt: indexPath, withSender: sender) ?? false
    }
    
    @available(iOS 5.0, *)
    public func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        tableDelegate?.tableView?(tableView, performAction: action, forRowAt: indexPath, withSender: sender)
    }
    
    
    // Focus
    
    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return tableDelegate?.tableView?(tableView, canFocusRowAt: indexPath) ?? false
    }
    
    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        return tableDelegate?.tableView?(tableView, shouldUpdateFocusIn: context) ?? true
    }
    
    @available(iOS 9.0, *)
    public func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        tableDelegate?.tableView?(tableView, didUpdateFocusIn: context, with: coordinator)
    }
    
    @available(iOS 9.0, *)
    public func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return tableDelegate?.indexPathForPreferredFocusedView?(in: tableView)
    }

}
